# Test case 1
#    - Sign an CSR uploaded through a web interface.
#
#      Use that, and the locally kept private key, to access
#      a secure area on the webserver.
#
# Test case 2
#    - Produce a PKCS#12 signed private/public keypair and
#      cert on the webserver (so we get no repudiation) and 
#      give it to us.
#
#      Use that cert to a secure area on the webserver.
#
# This demo/test sets up:
#
# 1.    tiny CA hierarcye; with a CA root that then
#       - issues a web service certificate to the webserver
#       - issues a separate `I validate persons' sub-CA.
#
# 2.    Sets up a apache httpd server with SSL. 
#
# 3.    Usecase 1: Hooks into that a red wax CSR signing module
#       on an area for which you need no authentication
# 
#       Usecase 2: Same - but now for issuing pkcs#12 key/cert
#       packages.
#
# 4.    Sets up an apache location that needs x509 client
#       authentication.
#
# 5.    Show that you cannot get a file from that location.
#
# 6.    Usecase 1: Then generate a CSR; gets it signed by above server
#       and then shows you can get the above file if you
#       use the issued client cert.
#
#       Usecase 2: Then ask for a certicate & private key from the server
#       and shows you can get the above file if you use the issued 
#  	client cer and private key given to you.
#
# 7.    And show that Malory; who somehow got her hands on the
#       servers private key -- cannot use that to get her hands
#       on the file.
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
  signWebRoot = "/data/http/demo";
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
          { name = "ca_simple"; path = "${pkgs.apacheHttpdPackages.mod_ca}/modules/mod_ca_simple.so"; }
          { name = "csr";       path = "${pkgs.apacheHttpdPackages.mod_csr}/modules/mod_csr.so"; }
          { name = "pkcs12";    path = "${pkgs.apacheHttpdPackages.mod_pkcs12}/modules/mod_pkcs12.so"; }
        ];
        virtualHosts = {
          "site.local" = {
            documentRoot = "${signWebRoot}/docroot";
            forceSSL = true;
            sslServerCert = "${signWebRoot}/keys/server.pem";
            sslServerKey =  "${signWebRoot}/keys/server.key";

            # We could just have ca-web.pem here; as curl already has
            # the ca. We do not do that - as having the full chain
            # advertised makes it easier for people to understand
            # what is happening if they have no notion of this 
            # particular ca (and they then also conveniently have the 
            # root to add to their local ca trust store).
            
            # Obsolete from apache-httpd-2.4.8; the chain should now be
            # in the server.pem file and ordered; as per below commented
            # out example.
            #
            sslServerChain = "${signWebRoot}/keys/chain-web.pem";
            # sslServerCert = "${signWebRoot}/keys/server-and-chain.pem";

            extraConfig = ''
              Header always set Strict-Transport-Security "max-age=15552000"

              # backend configuration:
              #
              # use system clock as the time source
              CASimpleTime on
              # assign a random serial number
              CASimpleSerialRandom on

              # Algorithm to use for signing certs; and the keys to use
              # for signing.
              #
              CASimpleAlgorithm   RSA
              CASimpleCertificate "${signWebRoot}/keys/ca-users.pem"
              CASimpleKey         "${signWebRoot}/keys/ca-users.key"

              # Not strictly needed - but a lot of desktop tools behave
              # more sensible when these v3 extensions are present; and
              # auto-prompt the user from the keystore.
              #
              CASimpleExtension basicConstraints CA:FALSE
              CASimpleExtension keyUsage critical,nonRepudiation,digitalSignature,keyEncipherment
              # See rfc5280 -- id-kp-clientAuth
              CASimpleExtension extendedKeyUsage OID:1.3.6.1.5.5.7.3.2 
              CASimpleExtension subjectKeyIdentifier hash
              CASimpleExtension authorityKeyIdentifier keyid,issuer

              # Number of days the issued certificate is valid for.
              #
              CASimpleDays 5

              # Front end Area were we can get a cert signed for use case 1.
              #
              <Location /issue>
                  SetHandler csr

                  # Fields that the user can supply (and how many)
                  #
                  CsrSubjectRequest CN 1
                  CsrSubjectRequest OU 1

                  # Fields that are under control of the webmaster, with
                  # fixed values.
                  #
                  CsrSubjectSet O "Cleansing Enterpises Ltd"
                  CsrSubjectSet L "Bittezauberhalte"
                  CsrSubjectSet C "DE"
              </Location>

              # Front end Area were we can get a signed cert and
              # a private key - test case 2.
              #
              <Location /issue12>
                  SetHandler pkcs12

                  # Fields that the user can supply (and how many)
                  #
                  Pkcs12SubjectRequest CN 1
                  Pkcs12SubjectRequest OU 1

                  # Fields that are under control of the webmaster, with
                  # fixed values.
                  #
                  Pkcs12SubjectSet O "Cleansing Enterpises Ltd"
                  Pkcs12SubjectSet L "Trusty Town"
                  Pkcs12SubjectSet C "DE"
              </Location>

              # Area requiring a x509 cert signed by 'us'. To show
              # that we need a signed cert as per above process. In
              # a more federated setting; where you'd accept people
              # vetted by your peers - you'd proably use a directory
              # with these (and SSLCACertificatePath). But if you just
              # trust a few - you can simply concatenate them.
              #
              SSLCACertificateFile "${signWebRoot}/keys/chain-user.pem"
              <Location /secrets>
                  SSLVerifyClient require
                  SSLVerifyDepth 2
              </Location>
            '';
          };
        };
      };

      environment.systemPackages = [ pkgs.openssl ];

      system.activationScripts.createDummyKey = ''
        set -xe

        dir="${signWebRoot}/keys"
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
        # We need this `split in two' to make it easier to stop Malory
        # from pretending to be a user if she has stolen a web server 
        # private key.
        #
        ${pkgs.openssl}/bin/openssl req -new -x509 -nodes -newkey rsa:1024 \
            -extensions v3_ca \
            -subj "$basedn/CN=CA" \
            -out $dir/ca.pem -keyout $dir/ca.key 

        # Now create our two sub CAs. One for the services and one for the users.
        # And sign each with the above root CA key.
        #
        cat >  $dir/extfile.cnf <<EOM
basicConstraints=CA:TRUE
EOM
        # We specify 'nodes' to not encrypt the private keys; as to not
        # need human interaction (typing in the password) during webserver
        # startup.
        #
        for subca in web users
        do
           ${pkgs.openssl}/bin/openssl req \
               -new -nodes -newkey rsa:1024  \
               -keyout $dir/ca-$subca.key \
               -subj "$basedn/CN=Sub CA for $subca" \
               -out $dir/ca-$subca.csr

           ${pkgs.openssl}/bin/openssl x509 -req -days 14 -set_serial $RANDOM \
               -CA $dir/ca.pem -CAkey $dir/ca.key \
               -extfile $dir/extfile.cnf \
               -in $dir/ca-$subca.csr \
               -out $dir/ca-$subca.pem

           rm $dir/ca-$subca.csr
        done

        # We know longer need the root CA key - as we've
        # signed our two worker sub CA's. And they'll
        # do the rest.
        #
        rm $dir/extfile.cnf $dir/ca.key

        # Make a full chain - somewhat superfluous, but polite nevertheless. See the comment
        # above near sslServerChain.
        #
        cat $dir/ca-web.pem $dir/ca.pem > $dir/chain-web.pem
        cat $dir/ca-users.pem $dir/ca.pem > $dir/chain-user.pem
        cat $dir/ca-*.pem $dir/ca.pem > $dir/chain.pem

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

        # Put a text file in the secet directory to test against.
        #
        mkdir -p "${signWebRoot}/docroot/secrets"

        echo A solid plan for world domination. > "${signWebRoot}/docroot/secrets/bizplan.txt"
        echo Nothing to see, now move along.> "${signWebRoot}/docroot/public.txt"

        find "${signWebRoot}" -type f -print
      '';
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("httpd.service")

    machine.succeed("journalctl  -u apache.service > /dev/stderr")

    # machine.succeed("find / -type f -name *error_log | xargs cat > /dev/stderr")
    # machine.succeed("find / -type f -name *error-log | xargs cat > /dev/stderr")

    # Show that we cannot access the secret directory without properly identifying; but
    # that we can see the public part just fine.
    #
    machine.succeed(
        "curl --cacert ${signWebRoot}/keys/ca.pem https://site.local/public.txt || journalctl  -u apache.service > /dev/stderr"
    )
    machine.fail(
        "curl --cacert ${signWebRoot}/keys/ca.pem https://site.local/secrets/bizplan.txt"
    )

    # Use case 1 -- Get a CSR signed; generate/keep the private key locally.
   
    # Next up - get ourselves a client certificate so we can see the secert bizplan.

    # create a signing request for Alice (in pkcs#10 format, the default)
    #
    machine.succeed(
        "openssl req -new -subj /CN=Ignored -nodes -out alice.csr -keyout alice.key"
    )

    # Offer it to the webserver for signing. Use the CA to check that we're talkinging
    # to a server we trust. And then sent it the CSR we generated along with the
    # values we want for the CN and the OU.
    #
    # Obviously - this is a bit fake - as this server signs anything. You'd normally
    # have some type of auth, temporary token or admin approval in here.
    #
    machine.succeed(
        "curl --cacert ${signWebRoot}/keys/ca.pem --data-urlencode subject-CN=Alice --data-urlencode subject-OU=PestControlDepartment --data-urlencode pkcs10@alice.csr https://site.local/issue > alice.p7"
    )

    # extract the signed public segment
    machine.succeed("openssl pkcs7 -in alice.p7 -inform DER -print_certs -out alice.crt")

    # Show the signature.
    #
    machine.succeed("openssl x509 -in alice.crt -noout -text > /dev/stderr")

    # And (just) the subject that actually got signed.
    machine.succeed("openssl x509 -in alice.crt -noout -subject > /dev/stderr")

    # Confirm that we can access the secret directory when we properly identify.
    #
    machine.succeed(
        "curl --cacert ${signWebRoot}/keys/ca.pem --cert alice.crt --key alice.key https://site.local/secrets/bizplan.txt > /dev/stderr"
    )

    # Use case 2 -- Have the whole generation happen on the sever side (so no repudation, Bob
    # has always trusted the system more than Alice).
    #
    # The challenge is a temporary password that will encrypt the returned p12 package.
    #
    machine.succeed(
        "curl --cacert ${signWebRoot}/keys/ca.pem --data-urlencode subject-CN=Bob --data-urlencode subject-OU=VerminControlDepartment  --data-urlencode challenge=foo https://site.local/issue12 > bob.p12"
    )

    # extract the signed public segment from the encrypted p12 package.
    #
    machine.succeed(
        "openssl pkcs12 -in bob.p12 -password pass:foo -nokeys         -out bob.crt"
    )
    machine.succeed(
        "openssl pkcs12 -in bob.p12 -password pass:foo -nocerts -nodes -out bob.key"
    )

    machine.succeed("openssl x509 -in bob.crt -noout -subject > /dev/stderr")

    # And show that Bob has access too.
    #
    machine.succeed(
        "curl --cacert ${signWebRoot}/keys/ca.pem --cert bob.crt --key bob.key https://site.local/secrets/bizplan.txt > /dev/stderr"
    )

    # And finally show that evil Malory - who managed to exfiltrate the private key of the
    # webserver by some hook or crook - can -not- abuse this to get access; despite the
    # keys rolling up to the same root.
    #
    machine.fail(
        "curl --cacert ${signWebRoot}/keys/ca.pem --cert ${signWebRoot}/keys/server.pem --key  ${signWebRoot}/keys/server.key https://site.local/secrets/bizplan.txt > /dev/stderr"
    )
  '';
})
