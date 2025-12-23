{ lib, pkgs, ... }:
{
  name = "tpm2";

  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation = {
        mountHostNixStore = true;
        useEFIBoot = true;
        tpm.enable = true;
      };

      users.users = {
        tss-user = {
          isNormalUser = true;
          extraGroups = [ "tss" ];
        };
      };

      security.sudo.wheelNeedsPassword = false;

      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
        abrmd.enable = true;
        tctiEnvironment.enable = true;
        tctiEnvironment.interface = "tabrmd";
        fapi.ekCertLess = true;
      };

      environment.systemPackages = [
        pkgs.tpm2-tools
        pkgs.openssl
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("tabrmd service started properly"):
        machine.succeed('[ `systemctl show tpm2-abrmd.service --property=Result` = "Result=success" ]')
        machine.succeed('[ `journalctl -b -u tpm2-abrmd.service | grep -c "Starting"` = "1" ]')

    with subtest("tpm2 cli works"):
        machine.succeed('tpm2 createprimary --hierarchy=o --key-algorithm=aes256 --attributes="fixedtpm|fixedparent|sensitivedataorigin|userwithauth|restricted|decrypt" --key-context=owner_root_key.ctx')
        machine.succeed('tpm2 create --parent-context=owner_root_key.ctx --key-algorithm=ecc256:ecdsa-sha256:null --attributes="fixedtpm|fixedparent|sensitivedataorigin|userwithauth|restricted|sign" --key-context=ecc_sign_key.ctx --creation-ticket=ecc_sign_key-creation_ticket.bin -f pem --output=ecc_sign_key_public.pem')
        machine.succeed('echo "A very important message." > message.txt')
        machine.succeed('tpm2 sign --key-context=ecc_sign_key.ctx --hash-algorithm=sha256 -f plain --signature message_signature.bin message.txt')
        machine.succeed('openssl dgst -verify ecc_sign_key_public.pem -signature message_signature.bin message.txt')
        machine.succeed('echo "evil addition!" >> message.txt')
        machine.fail('openssl dgst -verify ecc_sign_key_public.pem -signature message_signature.bin message.txt')

    def format_command(command, user):
        return f"runuser -u {user} -- bash -c '{command}'"
    def succeedu(command,user):
        return machine.succeed(format_command(command,user))
    def failu(command,user):
        return machine.fail(format_command(command,user))

    with subtest("tss2 cli works"):
        machine.succeed('tss2 provision')
        succeedu('tss2 createkey --path=HS/SRK/sign --type=sign --authValue=""',"tss-user")
        succeedu('tss2 gettpmblobs --path=HS/SRK/sign --tpm2bPublic=$HOME/sign_key_public.bin',"tss-user")
        succeedu('tpm2 print -t TPM2B_PUBLIC -f pem $HOME/sign_key_public.bin > $HOME/sign_key_public.pem',"tss-user")
        succeedu('echo "A very important message." > $HOME/message.txt',"tss-user")
        succeedu('tpm2 hash --hash-algorithm=sha256 --output=$HOME/message_hash.bin $HOME/message.txt',"tss-user")
        succeedu('tss2 sign --keyPath=HS/SRK/sign --digest=$HOME/message_hash.bin --signature=$HOME/message_signature.bin',"tss-user")
        succeedu('openssl dgst -verify $HOME/sign_key_public.pem -signature $HOME/message_signature.bin $HOME/message.txt',"tss-user")
        succeedu('echo "evil addition!" >> $HOME/message.txt',"tss-user")
        failu('openssl dgst -verify $HOME/sign_key_public.pem -signature $HOME/message_signature.bin $HOME/message.txt',"tss-user")
  '';
}
