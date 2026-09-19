# Test case for an RFC 3161 (RFC 5816) compliant timeserver (over HTTP).
#
# Here we timestamp (i.e. add a time & sign) a document. Using the timestamping
# protocol defined in RFC 3161 (and commonly supported in office tools - e.g. see
# 'TimeStamping Service' in Open Office / Libre Office).
# 
# This demo/test sets up:
#
# 1.	tiny CA hierarcye; with a CA root that then
#	- issues a web service certificate to the webserver
#	- issues a separate time stamping certificate.
#       The setup is slightly more complex as usual because
#       we need true x509v3 certificates; with the timeStamping
#   	marked as `critical' to please enterprise tools such
#	as those from Adobe and Microsoft.
#
# 2.	Sets up a apache httpd server with SSL.
#
# 3.	Hooks into that a red wax timesever module that
#	relies on the time of the operating system.
#
# 4.	Then generates a small 1kByte file to sign/timestamp.
#
# 5.	Uses curl to get this signed; checking that the
#	web server certificate is trusted (not that key - 
#	we'd just leak the SHA256 checksum of the document
#	that we wanted to sign (and the metadata that we'd
#	want to sign).
#
# 6.	The uses the 'CA' certificate and the path through
#  	the time server to check the signature on the
#	document its timestamp.
#
# Note that it is fairly common to have time servers running
# on port 80 / without encryption. Running the timeserver on
# https is mostly as it is good practice -and- to illustrate
# the point made in 2.1/#11 of RFC 3161 about using *different*
# keys for the transport security and for the time signature.
#
# The policy (TimestampDefaultPolicy) is set to a demo value; a
# real server would use one within their enterprise OID range.
#
# The requirements for this OID are laid down in RFC3628; an
# enterprise prefix can be requested through pen @ IANA.
#
# RedWax   Redwax aims to decentralise trust management so that the 
#	   values security, confidentiality and privacy can be upheld 
#          in public infrastructure and private interactions. 
#          http://redwax.eu
# 
# RFC3161: Internet X.509 Public Key Infrastructure Time-Stamp Protocol (TSP)
#          https://tools.ietf.org/html/rfc3161
#
# RFC5816  Update to specify the hash of the signer certificate when
# 	   a non SHA1 hash is used (SHA256 in this demo).
#          https://tools.ietf.org/html/rfc5816
# 
# RFC3628  Policy Requirements for Time-Stamping Authorities (TSAs)
#          https://www.ietf.org/rfc/rfc3628.txt
# make-test-python = yourtestfunction: (import "${pkgs.path}/nixos/tests/make-test-python.nix" yourtestfunction { inherit pkgs; }):
# import <nixos/tests/make-test-python.nix> ({ pkgs, ... }:
import ./make-test-python.nix ({ pkgs, ... }:
let
  tsWebRoot = "/data/http/ts";
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
        ${config.networking.primaryIPAddress} tts.local
      '';
      services.httpd = {
        enable = true;
        adminAddr = "admin@tts.local";
        extraModules = [
          { name = "ca";        path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca.so"; }
          { name = "ca_simple"; path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca_simple.so"; }
          { name = "timestamp"; path = "${pkgs.apacheHttpdPackages.mod_timestamp}/modules/mod_timestamp.so"; }
        ];
        virtualHosts = {
          "tts.local" = {
            documentRoot = tsWebRoot;
            forceSSL = true;
            sslServerKey =  "${tsWebRoot}/keys/server.key";
            sslServerCert = "${tsWebRoot}/keys/server.pem";
            extraConfig = ''
              Header always set Strict-Transport-Security "max-age=15552000"

              # backend configuration:
              #
              # use system clock as the time source
              CASimpleTime on
              # assign a random serial number
              CASimpleSerialRandom on

              <Location /timestamp>
                  SetHandler timestamp
                  TimestampSigningCertificate "${tsWebRoot}/keys/ts-service.pem"
                  TimestampSigningKey         "${tsWebRoot}/keys/ts-service.key"
                  TimestampDigest 		SHA256
                  TimestampDefaultPolicy 	1.2.3.4.5
                  Require all granted
              </Location>
            '';
          };
        };
      };

      environment.systemPackages = [ pkgs.openssl ];

      system.activationScripts.createDummyKey = ''
        set -xe

        dir="${tsWebRoot}/keys"
        mkdir -m 0700 -p $dir

	# We use a fairly 'valid' DN; as to not having to foil the default
	# checks for things like '2 char' country codes, etc.
	#
        basedn="/C=NL/ST=Zuid-Holland/L=Leiden/O=Koelie-kerk"

        # We need to construct two certificates; one for the web server (optional; http fine too)
        # and one for the time stamping sevice. See section 2.1/#11 of RFC 3161 for the rationale
        # behind separate keys/certs ((https://tools.ietf.org/html/rfc3161).
        
        # Generating CA - and use that to sign a server and service cert.
        #
        ${pkgs.openssl}/bin/openssl req -new -x509 -nodes -newkey rsa:1024 \
            -extensions v3_ca \
            -subj "$basedn/CN=CA" \
            -out $dir/ca.pem -keyout $dir/ca.key 

        # Generating key for server. We are a bit pedantic about subjectAltNames as
        # some enterprise tools that use time-stamping severs seem to be strict on this.
        #
        ${pkgs.openssl}/bin/openssl req -new -nodes -newkey rsa:1024  -keyout $dir/server.key \
            -subj "$basedn/CN=tts.local" \
            -extensions v3_req \
            -addext subjectAltName=DNS:tts.local \
            -out $dir/temp.csr

        # We're generating a v3 cert (as we need subjectAltName); which does
        # not have the requered extension block in the default openssl.cnf. So
        # we generate one.
	#
	# Note - we're avoiding reliance on true bash (bourne is enough) by
	# explictly creating the ext. files.
        #
        cat >  $dir/extfile.cnf <<EOM
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment 
EOM

        ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial 2 \
              -CA $dir/ca.pem -CAkey $dir/ca.key \
              -extfile $dir/extfile.cnf \
              -in $dir/temp.csr \
              -out $dir/server.pem
        rm $dir/temp.csr $dir/extfile.cnf

        # Generating key for service
        #
        ${pkgs.openssl}/bin/openssl req -new -nodes -newkey rsa:1024 -keyout $dir/ts-service.key \
            -subj "$basedn/CN=Grote klokken doen bim-bam - timestamps service" \
            -out $dir/temp.csr

        # The signed cert needs timestamping as a critical usage extension.
        #
        echo extendedKeyUsage=critical,timeStamping > $dir/extfile.cnf

        ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial 3 \
              -CA $dir/ca.pem -CAkey $dir/ca.key \
              -extfile $dir/extfile.cnf \
              -in $dir/temp.csr \
              -in $dir/temp.csr \
              -out $dir/ts-service.pem 
        rm $dir/temp.csr $dir/extfile.cnf

        # CA key not needed from this point onwards; as we've
        # signed verything we wanted to sign.
        rm $dir/ca.key 

        # We need a chain to verify the signature on the timestamp.
        #
        cat $dir/ts-service.pem $dir/ca.pem > $dir/fullchain-ts-service.pem
      '';
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("httpd.service")

    # generate a file to sign
    machine.succeed("dd if=/dev/urandom of=data.raw count=1 bs=1024")

    # create a signing request for this file
    machine.succeed(
        "openssl ts -query -data data.raw -cert -sha256 -no_nonce -out request.tsq"
    )

    # offer it to the signing server
    machine.succeed(
        "curl --cacert ${tsWebRoot}/keys/ca.pem -H Content-type:application/timestamp-query --data-binary @request.tsq https://tts.local/timestamp > reply.tsq"
    )

    # dump the content of the reply.
    #
    machine.succeed("openssl ts -reply -text -in reply.tsq")

    # verify that it is actually signed & valid - and matches the hash of our file
    #
    machine.succeed(
        "openssl ts -verify -in reply.tsq -data data.raw -CAfile ${tsWebRoot}/keys/fullchain-ts-service.pem"
    )

    # In this simple, cannonical case - we can also check straight against the CA - as there
    # is nothing in between.
    #
    machine.succeed(
        "openssl ts -verify -in reply.tsq -data data.raw -CAfile ${tsWebRoot}/keys/ca.pem"
    )
  '';
})
