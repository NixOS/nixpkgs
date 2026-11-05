{ modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/security/secrets/example/common/backend-plain.nix"
    "${modulesPath}/security/secrets/example/common/backend-age.nix"
    "${modulesPath}/security/secrets"
  ];

  secrets = {
    backends.defaults.store = "plain";
    settings.store.plain.hostDirectory = "/tmp/secrets/plain";

    settings.store.age = {
      hostDirectory = "/tmp/secrets/age";

      identity.host = toString ./age.txt;
      publicKeys = [
        "age13ar5t7vvsssmckjhjtngy3p5y0v4k896ecjrxveql9ysu8gxhe9sdar3k3"
      ];
    };

    store.ssh-split = {
      files."ed25519.key".backend = "age";
      files."ed25519.key.pub".backend = "plain";
      meta.backend = "age";

      generate =
        { pkgs, ... }:
        pkgs.writeShellScript "gen-ed25519" ''
          export PATH="${lib.makeBinPath [ pkgs.coreutils pkgs.openssh ]}"
          ssh-keygen -t ed25519 -f $out/ed25519.key -P ""
        '';
    };
  };
}
