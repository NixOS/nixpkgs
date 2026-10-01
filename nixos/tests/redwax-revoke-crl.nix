# RedWax test/demo of the CRL responder modules.
#
# This demo/test sets up:
#
# 1.    tiny CA hierarcye; with a CA root that then
#       - issues a web service certificate to the webserver
#       - issues a separate `I validate persons' sub-CA.
#       - issues a bunch of client certs to 'people'
#       - revoke a few of these.
#
# 2.    Sets up a apache httpd server without SSL to publish CRLs (plaintext, as is customary)
#
# 3.  	Check that this works.

# RedWax   Redwax aims to decentralise trust management so that the 
#          values security, confidentiality and privacy can be upheld 
#          in public infrastructure and private interactions. 
#          http://redwax.eu
#
# 
# make-test-python = yourtestfunction: (import "${pkgs.path}/nixos/tests/make-test-python.nix" yourtestfunction { inherit pkgs; }):
# import <nixos/tests/make-test-python.nix> ({ pkgs, ... }:
import ./make-test-python.nix ({ pkgs, ... }:
let
  revokeRoot = "/data/http/demo";
in
{
  name = "redwax";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ dirkx ];
  };

  machine =
    { config, ... }:
    { networking.firewall.enable = true;
      networking.firewall.rejectPackets = true;
      networking.firewall.allowPing = true;
      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} site.local
      '';
      services.httpd = {
        enable = true;
        adminAddr = "admin@site.local";
        extraModules = [
          { name = "ca";        path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca.so"; }
          { name = "ca_crl";    path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca_crl.so"; }
          { name = "crl";       path = "${pkgs.apacheHttpdPackages.mod_crl}/modules/mod_crl.so"; }
        ];
        virtualHosts = {
          "site.local" = {
            documentRoot = "${revokeRoot}/docroot";

            extraConfig = ''
              CACRLCertificateRevocationList "${revokeRoot}/keys/ca-users-crl.pem"

              <Location /crl>
                  SetHandler crl
              </Location>
            '';
          };
        };
      };

      environment.systemPackages = [ pkgs.openssl ];

      system.activationScripts.createDummyKey = ''
        set -xe

        dir="${revokeRoot}/keys"
        mkdir -m 0700 -p $dir

        # We use a fairly 'valid' DN; as to not having to foil the default
        # checks for things like '2 char' country codes, etc which are in
        # the standard openssl.conf.
        #
        basedn="/C=NL/ST=Zuid-Holland/L=Leiden/O=Cleansing Enterprises B.V"

        # Generating CA - and use that to sign a sign two sub CAs.
        # One that issues web server certs (that we'll use as a server)
        # and one that issues certificates to our users.
        #
        ${pkgs.openssl}/bin/openssl req -new -x509 -nodes -newkey rsa:1024 \
            -extensions v3_ca \
            -subj "$basedn/CN=CA" \
            -out $dir/ca.pem -keyout $dir/ca.key 

        # Now create our two sub CAs. One for the services and one for the users.
        # And sign each with the above root CA key.
        #
        # We specify 'nodes' to not encrypt the private keys; as to not
        # need human interaction (typing in the password) during webserver
        # startup.
        #
        cat >  $dir/extfile.cnf <<EOM
basicConstraints=CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
EOM
        ${pkgs.openssl}/bin/openssl req \
               -new -nodes -newkey rsa:1024  \
               -keyout $dir/ca-users.key \
               -subj "$basedn/CN=Sub CA for users" |\
        ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial $RANDOM \
               -CA $dir/ca.pem -CAkey $dir/ca.key \
               -extfile $dir/extfile.cnf \
               -out $dir/ca-users.pem

        rm $dir/extfile.cnf $dir/ca.key

        cat $dir/ca.pem $dir/ca-users.pem > $dir/chain.pem

        # Set up a minimal CA config that can create & revoke certicates. And include
        # in the generated certs the vaiorus CRL endpoints for this demo.
        #
        mkdir $dir/certs $dir/crl $dir/newcerts
        touch $dir/index.txt
	echo 01 > $dir/serial.txt
	echo 01 > $dir/crlnumber.txt
        cat >  $dir/openssl.cnf <<EOM
[ca]
default_ca = CA_default

[CA_default]
certs=$dir/certs
new_certs_dir= $dir/newcerts
# crl_dir=$dir/crl
serial=$dir/serial.txt
certificate=$dir/ca-users.pem
private_key=$dir/ca-users.key
default_md        = sha256
database=$dir/index.txt
default_days      = 30
crlnumber         = $dir/crlnumber.txt
crl               = $dir/ca.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 3
policy            = policy

[policy]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
emailAddress            = optional
commonName              = supplied

[ req ]
default_bits        = 2048
distinguished_name  = req_distinguished_name
string_mask         = utf8only
default_md          = sha256
x509_extensions     = v3_ca

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ req_distinguished_name ]

[ usr_cert ]
basicConstraints=CA:FALSE
crlDistributionPoints = URI:http://site.local/crl
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ crl_ext ]
authorityKeyIdentifier=keyid:always
EOM
        # Now issue certicates to our usually menagerie of users
        #
        for person in alice charlie malory
        do
           ${pkgs.openssl}/bin/openssl req \
               -config $dir/openssl.cnf \
               -new -nodes -newkey rsa:1024  \
               -keyout /dev/null \
               -subj "$basedn/CN=$person" \
               -extensions usr_cert \
               -out $dir/person-$person.crt

           s=`cat $dir/serial.txt`
           ${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
		-extensions usr_cert  -batch \
		-in  $dir/person-$person.crt \
		-out $dir/person-$person.pem  
        done

        cat $dir/index.txt

        # Revoke Malory - she is up to no good. Again. 
        # Then regenerate and resign the CRL.
        #
  	${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
		-batch \
		-revoke $dir/person-malory.pem

        # And charlie changed jobs
        #
  	${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
		-batch \
                -crl_reason affiliationChanged \
		-revoke $dir/person-charlie.pem

  	${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
		-batch \
		-gencrl \
		-out $dir/ca-users-crl.pem 

        # Just to quell a webserver error & warning.
	# 
        mkdir ${revokeRoot}/docroot
        echo Nothing to see, now move along > ${revokeRoot}/docroot/index.html
      '';
    };

  testScript = ''
    # Validate alice and malory their certs against the CA; both should be ok (as this
    # does not check the CRL).
    #
    machine.succeed(
        "openssl verify -trusted ${revokeRoot}/keys/ca.pem -untrusted ${revokeRoot}/keys/ca-users.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-charlie.pem"
    )
    machine.succeed(
        "openssl verify -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-malory.pem"
    )

    # Now check again - against the CRL file (which we fetch from disk - not through the CRL http
    # endpoint. Now only Malory should fail.
    #
    machine.succeed(
        "openssl verify -CRLfile ${revokeRoot}/keys/ca-users-crl.pem  -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CRLfile ${revokeRoot}/keys/ca-users-crl.pem  -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-charlie.pem"
    )
    machine.succeed(
        "openssl verify -CRLfile ${revokeRoot}/keys/ca-users-crl.pem  -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-malory.pem"
    )

    # Now check again - with the CRL check - and while the CRL server is still DOWN. So both
    # checks should fail.
    #
    # Commented out - as the time out on the failing network check is rather long.
    #
    # machine.fail(
    #    "openssl verify -verbose -CAfile ${revokeRoot}/keys/chain.pem -crl_check -crl_download ${revokeRoot}/keys/person-alice.pem"
    # )
    # machine.fail(
    #    "openssl verify -verbose -CAfile ${revokeRoot}/keys/chain.pem -crl_check -crl_download ${revokeRoot}/keys/person-malory.pem"
    # )

    # Start everything - and wait for the CRL responder to be up - and try it again. Now just Malory
    # should fail.
    #
    start_all()
 
    machine.wait_for_unit("httpd.service")

    # First - fetch the raw thing. And display it in a human readable format.
    # (this also valdiates the certiciates - ca-user issues).
    #
    machine.succeed(
        "curl --cacert ${revokeRoot}/keys/ca.pem http://site.local/crl > crl.der"
    )
    machine.succeed(
        "openssl crl -CAfile ${revokeRoot}/keys/chain.pem -in crl.der -inform DER -text -noout > /dev/stderr"
    )

    # And now interact with it using the endpoint `live' from a verify - first show the URI (there is no
    # CRL equivalent for -ocsp_uri; hence the grep)
    #
    machine.succeed(
        "openssl x509 -text -noout -in ${revokeRoot}/keys/person-alice.pem | grep URI > /dev/stderr"
    )

    # And then check the validity of Alice her certificate.
    #
    machine.succeed(
        "openssl verify -verbose -CAfile ${revokeRoot}/keys/chain.pem -crl_check -show_chain -crl_download ${revokeRoot}/keys/person-alice.pem > /dev/stderr"
    )

    # Charlie and Malory are both revoked - so these two test should both fail.
    #
    machine.fail(
        "openssl verify -verbose -CAfile ${revokeRoot}/keys/chain.pem -crl_check -show_chain -crl_download ${revokeRoot}/keys/person-malory.pem > /dev/stderr"
    )
    machine.fail(
        "openssl verify -verbose -CAfile ${revokeRoot}/keys/chain.pem -crl_check -show_chain -crl_download ${revokeRoot}/keys/person-charlie.pem > /dev/stderr"
    )
  '';
})
