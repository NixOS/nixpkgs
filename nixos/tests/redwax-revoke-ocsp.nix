# RedWax test/demo of the OCSP and CRL responder modules.
#
# This demo/test sets up:
#
# 1.    tiny CA hierarcye; with a CA root that then
#       - issues a web service certificate to the webserver
#       - issues a separate `I validate persons' sub-CA.
#       - issues a bunch of client certs to 'people'
#       - revoke a few of these.
#
# 2.    Sets up a apache httpd server with SSL to host an OCSP endpoint
#
# 3.    Check that this works.
#
# Note that we'll use a OCSP specific certificate to sign the OCSP
#      response. As opposed to signing it with the CA that issued
#      the certificates that are revoked. This way we can limit
#      the damage in case that OCSP private key leaks out (as all
#      it can done due to its critical extension/CA:FALSE is
#      sign OCSP responses.
#
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
      networking.firewall.allowedTCPPorts = [ 443 ];
      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} site.local
      '';
      services.httpd = {
        enable = true;
        adminAddr = "admin@site.local";
        extraModules = [
          { name = "ca";        path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca.so"; }
          { name = "ca_simple";    path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca_simple.so"; }
          { name = "ca_crl";    path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca_crl.so"; }
          { name = "ocsp";      path = "${pkgs.apacheHttpdPackages.mod_ocsp}/modules/mod_ocsp.so"; }
        ];
        virtualHosts = {
          "site.local" = {
            documentRoot = "${revokeRoot}/docroot";
            # We need port 80; as openssl does not know how to
            # fetch CRLs over https.
            #
            forceSSL = true;
            sslServerCert = "${revokeRoot}/keys/server.pem";
            sslServerKey =  "${revokeRoot}/keys/server.key";

            # Obsolete from apache-httpd-2.4.8; the chain should now be
            # in the server.pem file and ordered; as per below commented
            # out example.
            #
            # sslServerChain = "${revokeRoot}/keys/chain-web.pem";
            # sslServerCert = "${revokeRoot}/keys/server-and-chain.pem";

            extraConfig = ''

              # Source of our revoked certs list:
              CACRLCertificateRevocationList "${revokeRoot}/keys/ca-users-crl.pem"

              # The CA this OCSP endpoint is for:
              CASimpleCertificate "${revokeRoot}/keys/ca-users.pem"

              <Location /ocsp>
                  SetHandler ocsp

                  OcspSigningCertificate "${revokeRoot}/keys/ocsp.pem"
                  OcspSigningKey "${revokeRoot}/keys/ocsp.key"
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
basicConstraints = CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
EOM
        for subca in web users
        do
           ${pkgs.openssl}/bin/openssl req \
               -new -nodes -newkey rsa:1024  \
               -keyout $dir/ca-$subca.key \
               -subj "$basedn/CN=Sub CA for $subca" |\
           ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial $RANDOM \
               -CA $dir/ca.pem -CAkey $dir/ca.key \
               -extfile $dir/extfile.cnf \
               -out $dir/ca-$subca.pem
        done

        # Create an OCSP signer; as we want to avoid having to have
        # the key of the ca-users near the web-server; we create a
        # more neutered one (CA:False, critical on just OCSP signing).
        #
  	# Standards (and openssl) expect this ocsp signing cert to be
        # under the same CA as the one that it signs OCSP related
        # requests of.
        #
        cat >  $dir/extfile.cnf <<EOM
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
EOM
        ${pkgs.openssl}/bin/openssl req \
               -new -nodes -newkey rsa:1024  \
               -keyout $dir/ocsp.key \
               -subj "$basedn/CN=OCSP Department" |\
        ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial $RANDOM \
               -CA $dir/ca-users.pem -CAkey $dir/ca-users.key \
               -extfile $dir/extfile.cnf \
               -out $dir/ocsp.pem

        # We no longer need the root CA key - as we've
        # signed our two worker sub CA's. And they'll
        # do the rest.
        #
        rm $dir/extfile.cnf $dir/ca.key

        # Make a full chain - somewhat superfluous, but polite nevertheless. See the comment
        # above near sslServerChain.
        #
        cat $dir/ca-web.pem $dir/ca.pem > $dir/chain-web.pem
        cat $dir/ca-users.pem $dir/ca.pem > $dir/chain-user.pem
        cat $dir/ocsp.pem $dir/ca.pem > $dir/chain-ocsp.pem
        cat $dir/ca.pem $dir/ca-*.pem $dir/ocsp.pem  > $dir/chain.pem

        # Use the CA Web sub ca to sign a localhost cert. We keep this very simple; a
        # more realistic example would set all sort of x509v3 extensions; such as an
        # key IDs and SubjectAltNames.
        #
        ${pkgs.openssl}/bin/openssl req -new -nodes -newkey rsa:1024  -keyout $dir/server.key \
            -subj "$basedn/CN=site.local" \
            -out $dir/server.csr

        ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial $RANDOM \
              -CA $dir/ca-web.pem -CAkey $dir/ca-web.key \
              -in $dir/server.csr \
              -out $dir/server.pem
        rm $dir/server.csr

        # SSLCertificateChainFile was obsoleted in apache 2.4.8 - its role taken over by
        # having them concatenated into SSLCertificateFile. So we create that here; sorted
        # from leaf to root.
        cat $dir/server.pem $dir/ca-users.pem $dir/ca.pem > $dir/server-and-chain.pem

        # We know longer need the Web CA key; but we do keep the ca-users key; as that
        # is what the service needs to sign certificate requests.
        #
        rm $dir/ca-web.key

        # Set up a minimal CA config that can create & revoke certicates. And include
        # in the generated certs the vaiorus OCSP and CRL endpoints for this demo.
        #
        # Note: This is a bit more complex than it should be; but we need to do this because
        # mod_ca_simple/ca_crl is too simple; it only takes normal CRL files at this time.
        # And the other option (LDAP) is even more complex to set up.
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
# authorityInfoAccess = OCSP;URI:https://site.local/ocsp, caIssuers; URI:https://site.local/web-users.crt
authorityInfoAccess = OCSP;URI:https://site.local/ocsp
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ crl_ext ]
authorityKeyIdentifier=keyid:always

[ ocsp ]
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
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

           rm $dir/person-$person.crt
           # cp $dir/newcerts/$s.pem $dir/person-$person.pem
        done

        cat $dir/index.txt

        # Revoke Malory - she is up to no good. Again.
        #
        ${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
                -batch \
                -revoke $dir/person-malory.pem

        # Revoke Charlie - he is now working somewhere else.
        #
        ${pkgs.openssl}/bin/openssl ca -config $dir/openssl.cnf \
                -batch \
                -crl_reason affiliationChanged \
                -revoke $dir/person-charlie.pem

        # Then regenerate and resign the CRL.
        #
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
    # First we validate that w've set up the certs/revocs correctly.

    # Validate alice and malory their certs against the CA; both should be ok (as this
    # does not check the OCSP responder / crl file.
    #
    machine.succeed(
        "openssl verify -trusted ${revokeRoot}/keys/ca.pem -untrusted ${revokeRoot}/keys/ca-users.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CAfile ${revokeRoot}/keys/chain-user.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-malory.pem"
    )

    # Now check again - against the CRL file (which we fetch from disk). Now only Malory should fail.
    #
    machine.succeed(
        "openssl verify -CRLfile ${revokeRoot}/keys/ca-users-crl.pem  -CAfile ${revokeRoot}/keys/chain-user.pem ${revokeRoot}/keys/person-alice.pem"
    )
    machine.succeed(
        "openssl verify -CRLfile ${revokeRoot}/keys/ca-users-crl.pem  -CAfile ${revokeRoot}/keys/chain.pem ${revokeRoot}/keys/person-malory.pem"
    )
    # Check that we have the right URI
    #
    machine.succeed(
        "openssl x509 -noout -ocsp_uri -in ${revokeRoot}/keys/person-alice.pem | grep 'https://site.local/ocsp' > /dev/stderr"
    )
    # And this completes the setup test. next up is the actual
    # OCSP endpoint test.

    start_all()
    machine.wait_for_unit("httpd.service")

    machine.succeed(
        "openssl ocsp -issuer ${revokeRoot}/keys/ca-users.pem -CAfile ${revokeRoot}/keys/ca.pem -cert ${revokeRoot}/keys/person-alice.pem -cert ${revokeRoot}/keys/person-charlie.pem -cert ${revokeRoot}/keys/person-malory.pem -resp_text -url https://site.local/ocsp > /dev/stderr"
    )

    # This should show something such as:
    #
    #   OCSP Response Data:
    #   ....
    #         detailed information & signature certificate
    #   ....
    #   Response verify OK
    #   /data/http/demo/keys/person-alice.pem: good
    #         This Update: Feb 15 22:10:32 2020 GMT
    #         Next Update: Feb 18 22:10:32 2020 GMT
    #   /data/http/demo/keys/person-charlie.pem: revoked
    #         This Update: Feb 15 22:10:32 2020 GMT
    #         Next Update: Feb 18 22:10:32 2020 GMT
    #         Reason: affiliationChanged
    #         Revocation Time: Feb 15 22:10:32 2020 GMT
    #   /data/http/demo/keys/person-malory.pem: revoked
    #         This Update: Feb 15 22:10:32 2020 GMT
    #         Next Update: Feb 18 22:10:32 2020 GMT
    #         Reason: unspecified
    #         Revocation Time: Feb 15 22:10:31 2020 GMT
  '';
})
