import ../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    inherit (pkgs) writeText tpm2-tools openssl;
    ek_config = writeText "ek-sign.cnf" ''
      [ tpm_policy ]
      basicConstraints = CA:FALSE

      keyUsage = keyEncipherment
      certificatePolicies = 2.23.133.2.1
      extendedKeyUsage = 2.23.133.8.1

      subjectAltName = ASN1:SEQUENCE:dirname_tpm

      [ dirname_tpm ]
      seq = EXPLICIT:4,SEQUENCE:dirname_tpm_seq

      [ dirname_tpm_seq ]
      set = SET:dirname_tpm_set

      [ dirname_tpm_set ]
      seq.1 = SEQUENCE:dirname_tpm_seq_manufacturer
      seq.2 = SEQUENCE:dirname_tpm_seq_model
      seq.3 = SEQUENCE:dirname_tpm_seq_version

      # We're going to mock up an STM TPM here
      [dirname_tpm_seq_manufacturer]
      oid = OID:2.23.133.2.1
      str = UTF8:"id:53544D20"

      [dirname_tpm_seq_model]
      oid = OID:2.23.133.2.2
      str = UTF8:"ST33HTPHAHD4

      [dirname_tpm_seq_version]
      oid = OID:2.23.133.2.3
      str = UTF8:"id:00010101"
    '';
  in
  {
    name = "tpm-ek";

    meta = {
      maintainers = with lib.maintainers; [ baloo ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          openssl
          tpm2-tools
        ];

        security.tpm2 = {
          enable = true;
          tctiEnvironment.enable = true;
        };

        virtualisation.tpm = {
          enable = true;
          provisioning = ''
            export PATH=${
              lib.makeBinPath [
                openssl
              ]
            }:$PATH

            tpm2_createek -G rsa -u ek.pub -c ek.ctx -f pem

            # Sign a certificate
            # Pretend we're an STM TPM
            openssl x509 \
              -extfile ${ek_config} \
              -new -days 365 \
              \
              -subj "/CN=this.is.required.but.it.should.not/" \
              -extensions tpm_policy \
              \
              -CA ${./ca.crt} -CAkey ${./ca.priv} \
              \
              -out device.der -outform der \
              -force_pubkey ek.pub

            # Create a nvram slot for the certificate, and we need the size
            # to precisely match the length of the certificate we're going to
            # put in.
            tpm2_nvdefine 0x01c00002 \
              -C o \
              -a "ownerread|policyread|policywrite|ownerwrite|authread|authwrite" \
              -s "$(wc -c device.der| cut -f 1 -d ' ')"

            tpm2_nvwrite 0x01c00002 -C o -i device.der
          '';
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      machine.succeed('tpm2_nvread 0x01c00002 | openssl x509 -inform der -out /tmp/ek.pem')
      print(machine.succeed('openssl x509 -in /tmp/ek.pem -text'))
      machine.succeed('openssl verify -CAfile ${./ca.crt} /tmp/ek.pem')
    '';
  }
)
