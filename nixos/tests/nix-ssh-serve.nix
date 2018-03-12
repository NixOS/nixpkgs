import ./make-test.nix ({ pkgs, lib, ... }:
let inherit (import ./ssh-keys.nix pkgs)
      snakeOilPrivateKey snakeOilPublicKey;
    ssh-config = builtins.toFile "ssh.conf" ''
      UserKnownHostsFile=/dev/null
      StrictHostKeyChecking=no
    '';
in
   { name = "nix-ssh-serve";
     meta.maintainers = [ lib.maintainers.shlevy ];
     nodes =
       { server.nix.sshServe =
           { enable = true;
             keys = [ snakeOilPublicKey ];
             protocol = "ssh-ng";
           };
         server.nix.package = pkgs.nixUnstable;
         client.nix.package = pkgs.nixUnstable;
       };
     testScript = ''
       startAll;

       $client->succeed("mkdir -m 700 /root/.ssh");
       $client->copyFileFromHost("${ssh-config}", "/root/.ssh/config");
       $client->succeed("cat ${snakeOilPrivateKey} > /root/.ssh/id_ecdsa");
       $client->succeed("chmod 600 /root/.ssh/id_ecdsa");

       $client->succeed("nix-store --add /etc/machine-id > mach-id-path");

       $server->waitForUnit("sshd");

       $client->fail("diff /root/other-store\$(cat mach-id-path) /etc/machine-id");
       # Currently due to shared store this is a noop :(
       $client->succeed("nix copy --to ssh-ng://nix-ssh\@server \$(cat mach-id-path)");
       $client->succeed("nix-store --realise \$(cat mach-id-path) --store /root/other-store --substituters ssh-ng://nix-ssh\@server");
       $client->succeed("diff /root/other-store\$(cat mach-id-path) /etc/machine-id");
     '';
   }
)
