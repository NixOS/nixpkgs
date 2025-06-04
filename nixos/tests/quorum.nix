{ pkgs, ... }:
let
  keystore = {
    address = "9377bc3936de934c497e22917b81aa8774ac3bb0";
    crypto = {
      cipher = "aes-128-ctr";
      ciphertext = "ad8341d8ef225650403fd366c955f41095e438dd966a3c84b3d406818c1e366c";
      cipherparams = {
        iv = "2a09f7a72fd6dff7c43150ff437e6ac2";
      };
      kdf = "scrypt";
      kdfparams = {
        dklen = 32;
        n = 262144;
        p = 1;
        r = 8;
        salt = "d1a153845bb80cd6274c87c5bac8ac09fdfac5ff131a6f41b5ed319667f12027";
      };
      mac = "a9621ad88fa1d042acca6fc2fcd711f7e05bfbadea3f30f379235570c8e270d3";
    };
    id = "89e847a3-1527-42f6-a321-77de0a14ce02";
    version = 3;
  };
  keystore-file = pkgs.writeText "keystore-file" (builtins.toJSON keystore);
in
{
  name = "quorum";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.quorum = {
          enable = true;
          permissioned = false;
          staticNodes = [
            "enode://dd333ec28f0a8910c92eb4d336461eea1c20803eed9cf2c056557f986e720f8e693605bba2f4e8f289b1162e5ac7c80c914c7178130711e393ca76abc1d92f57@0.0.0.0:30303?discport=0"
          ];
          genesis = {
            alloc = {
              "189d23d201b03ae1cf9113672df29a5d672aefa3" = {
                balance = "0x446c3b15f9926687d2c40534fdb564000000000000";
              };
              "44b07d2c28b8ed8f02b45bd84ac7d9051b3349e6" = {
                balance = "0x446c3b15f9926687d2c40534fdb564000000000000";
              };
              "4c1ccd426833b9782729a212c857f2f03b7b4c0d" = {
                balance = "0x446c3b15f9926687d2c40534fdb564000000000000";
              };
              "7ae555d0f6faad7930434abdaac2274fd86ab516" = {
                balance = "0x446c3b15f9926687d2c40534fdb564000000000000";
              };
              c1056df7c02b6f1a353052eaf0533cc7cb743b52 = {
                balance = "0x446c3b15f9926687d2c40534fdb564000000000000";
              };
            };
            coinbase = "0x0000000000000000000000000000000000000000";
            config = {
              byzantiumBlock = 1;
              chainId = 10;
              eip150Block = 1;
              eip150Hash = "0x0000000000000000000000000000000000000000000000000000000000000000";
              eip155Block = 1;
              eip158Block = 1;
              homesteadBlock = 1;
              isQuorum = true;
              istanbul = {
                epoch = 30000;
                policy = 0;
              };
            };
            difficulty = "0x1";
            extraData = "0x0000000000000000000000000000000000000000000000000000000000000000f8aff869944c1ccd426833b9782729a212c857f2f03b7b4c0d94189d23d201b03ae1cf9113672df29a5d672aefa39444b07d2c28b8ed8f02b45bd84ac7d9051b3349e694c1056df7c02b6f1a353052eaf0533cc7cb743b52947ae555d0f6faad7930434abdaac2274fd86ab516b8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0";
            gasLimit = "0xe0000000";
            gasUsed = "0x0";
            mixHash = "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365";
            nonce = "0x0";
            number = "0x0";
            parentHash = "0x0000000000000000000000000000000000000000000000000000000000000000";
            timestamp = "0x5cffc201";
          };
        };
      };
  };

  testScript = ''
    start_all()
    machine.succeed("mkdir -p /var/lib/quorum/keystore")
    machine.succeed(
        'cp ${keystore-file} /var/lib/quorum/keystore/UTC--2020-03-23T11-08-34.144812212Z--${keystore.address}'
    )
    machine.succeed(
        "echo fe2725c4e8f7617764b845e8d939a65c664e7956eb47ed7d934573f16488efc1 > /var/lib/quorum/nodekey"
    )
    machine.succeed("systemctl restart quorum")
    machine.wait_for_unit("quorum.service")
    machine.sleep(15)
    machine.succeed('geth attach /var/lib/quorum/geth.ipc --exec "eth.accounts" | grep ${keystore.address}')
  '';
}
