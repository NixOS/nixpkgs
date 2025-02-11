import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    domain = "sourcehut.localdomain";
  in
  {
    name = "sourcehut";

    meta.maintainers = with pkgs.lib.maintainers; [
      tomberek
      nessdoor
    ];

    nodes.machine =
      {
        config,
        pkgs,
        nodes,
        ...
      }:
      {
        imports = [
          ./nodes/common.nix
        ];

        networking.domain = domain;
        networking.extraHosts = ''
          ${config.networking.primaryIPAddress} git.${domain}
          ${config.networking.primaryIPAddress} meta.${domain}
        '';

        services.sourcehut = {
          git.enable = true;
          settings."git.sr.ht" = {
            oauth-client-secret = pkgs.writeText "gitsrht-oauth-client-secret" "3597288dc2c716e567db5384f493b09d";
            oauth-client-id = "d07cb713d920702e";
          };
        };

        environment.systemPackages = with pkgs; [
          git
        ];
      };

    testScript =
      let
        userName = "nixos-test";
        userPass = "AutoNixosTestPwd";
        hutConfig = pkgs.writeText "hut-config" ''
          instance "${domain}" {
            # Will be replaced at runtime with the generated token
            access-token "OAUTH-TOKEN"
          }
        '';
        sshConfig = pkgs.writeText "ssh-config" ''
          Host git.${domain}
               IdentityFile = ~/.ssh/id_rsa
        '';
      in
      ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        machine.wait_for_unit("sshd.service")

        with subtest("Check whether meta comes up"):
             machine.wait_for_unit("metasrht-api.service")
             machine.wait_for_unit("metasrht.service")
             machine.wait_for_unit("metasrht-webhooks.service")
             machine.wait_for_open_port(5000)
             machine.succeed("curl -sL http://localhost:5000 | grep meta.${domain}")
             machine.succeed("curl -sL http://meta.${domain} | grep meta.${domain}")

        with subtest("Create a new user account and OAuth access key"):
             machine.succeed("echo ${userPass} | metasrht-manageuser -ps -e ${userName}@${domain}\
                              -t active_paying ${userName}");
             (_, token) = machine.execute("srht-gen-oauth-tok -i ${domain} -q ${userName} ${userPass}")
             token = token.strip().replace("/", r"\\/") # Escape slashes in token before passing it to sed
             machine.execute("mkdir -p ~/.config/hut/")
             machine.execute("sed s/OAUTH-TOKEN/" + token + "/ ${hutConfig} > ~/.config/hut/config")

        with subtest("Check whether git comes up"):
             machine.wait_for_unit("gitsrht-api.service")
             machine.wait_for_unit("gitsrht.service")
             machine.wait_for_unit("gitsrht-webhooks.service")
             machine.succeed("curl -sL http://git.${domain} | grep git.${domain}")

        with subtest("Add an SSH key for Git access"):
             machine.execute("ssh-keygen -q -N \"\" -t rsa -f ~/.ssh/id_rsa")
             machine.execute("cat ${sshConfig} > ~/.ssh/config")
             machine.succeed("hut meta ssh-key create ~/.ssh/id_rsa.pub")

        with subtest("Create a new repo and push contents to it"):
             machine.execute("git init test")
             machine.execute("echo \"Hello world!\" > test/hello.txt")
             machine.execute("cd test && git add .")
             machine.execute("cd test && git commit -m \"Initial commit\"")
             machine.execute("cd test && git tag v0.1")
             machine.succeed("cd test && git remote add origin gitsrht@git.${domain}:~${userName}/test")
             machine.execute("( echo -n 'git.${domain} '; cat /etc/ssh/ssh_host_ed25519_key.pub ) > ~/.ssh/known_hosts")
             machine.succeed("hut git create test")
             machine.succeed("cd test && git push --tags --set-upstream origin master")

        with subtest("Verify that the repo is downloadable and its contents match the original"):
             machine.succeed("curl https://git.${domain}/~${userName}/test/archive/v0.1.tar.gz | tar -xz")
             machine.succeed("diff test-v0.1/hello.txt test/hello.txt")
      '';
  }
)
