import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
    xxh-shell-zsh = pkgs.stdenv.mkDerivation {
      pname = "xxh-shell-zsh";
      version = "";
      src = pkgs.fetchFromGitHub {
        owner = "xxh";
        repo = "xxh-shell-zsh";
        # gets rarely updated, we can then just replace the hash
        rev = "91e1f84f8d6e0852c3235d4813f341230cac439f";
        sha256 = "sha256-Y1FrIRxTd0yooK+ZzKcCd6bLSy5E2fRXYAzrIsm7rIc=";
      };

      postPatch = ''
        substituteInPlace build.sh \
          --replace "echo Install wget or curl" "cp ${zsh-portable-binary} zsh-5.8-linux-x86_64.tar.gz" \
          --replace "command -v curl" "command -v this-should-not-trigger"
      '';

      installPhase = ''
        mkdir -p $out
        mv * $out/
      '';
    };

    zsh-portable-binary = pkgs.fetchurl {
      # kept in sync with https://github.com/xxh/xxh-shell-zsh/tree/master/build.sh#L27
      url = "https://github.com/romkatv/zsh-bin/releases/download/v3.0.1/zsh-5.8-linux-x86_64.tar.gz";
      sha256 = "sha256-i8flMd2Isc0uLoeYQNDnOGb/kK3oTFVqQgIx7aOAIIo=";
    };
  in
  {
    name = "xxh";
    meta = with lib.maintainers; {
      maintainers = [ lom ];
    };

    nodes = {
      server =
        { ... }:
        {
          services.openssh.enable = true;
          users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        };

      client =
        { ... }:
        {
          programs.zsh.enable = true;
          users.users.root.shell = pkgs.zsh;
          environment.systemPackages = with pkgs; [
            xxh
            git
          ];
        };
    };

    testScript = ''
      start_all()

      client.succeed("mkdir -m 700 /root/.ssh")

      client.succeed(
         "cat ${snakeOilPrivateKey} > /root/.ssh/id_ecdsa"
      )
      client.succeed("chmod 600 /root/.ssh/id_ecdsa")

      server.wait_for_unit("sshd")

      client.succeed("xxh server -i /root/.ssh/id_ecdsa +hc \'echo $0\' +i +s zsh +I xxh-shell-zsh+path+${xxh-shell-zsh} | grep -Fq '/root/.xxh/.xxh/shells/xxh-shell-zsh/build/zsh-bin/bin/zsh'")
    '';
  }
)
