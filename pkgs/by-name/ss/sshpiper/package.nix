{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "tg123";
    repo = "sshpiper";
    tag = "v${version}";
    hash = "sha256-rxQwRXfY+9eqiAFH2XYysIIqRXmZ3Q2GVbogE9reouk=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-6aFosAOyJkxVpRZCCCMQK7myIzOV3uE8Bon5qtklL/U=";

  common = {
    inherit src version vendorHash;

    env.CGO_ENABLED = "0";

    ldflags = [
      "-s"
      "-w"
      "-X main.mainver=${version}"
    ];
  };

  buildPlugin =
    name:
    buildGoModule (
      common
      // {
        pname = "sshpiper-plugin-${name}";
        subPackages = [ "plugin/${name}" ];
        tags = [ "full" ];

        postInstall = ''
          mkdir -p $out/lib/sshpiper/plugins
          mv $out/bin/${name} $out/lib/sshpiper/plugins/${name}
          rmdir $out/bin
        '';

        meta = {
          description = "sshpiper ${name} plugin";
          homepage = "https://github.com/tg123/sshpiper";
          license = lib.licenses.mit;
          platforms = lib.platforms.linux;
        };
      }
    );

  plugins = map buildPlugin [
    "failtoban"
    "fixed"
    "lua"
    "metrics"
    "username-router"
    "workingdir"
    "yaml"
  ];
in
buildGoModule (
  common
  // {
    pname = "sshpiper";
    subPackages = [ "cmd/sshpiperd" ];

    postInstall = ''
      mkdir -p $out/lib/sshpiper/plugins
      for plugin in ${lib.concatMapStringsSep " " (p: "${p}/lib/sshpiper/plugins/*") plugins}; do
        ln -s "$plugin" "$out/lib/sshpiper/plugins/$(basename "$plugin")"
      done
    '';

    passthru.tests = {
      nixos = nixosTests.sshpiper;
    };

    meta = {
      description = "Reverse proxy for SSH";
      longDescription = ''
        sshpiper is a reverse proxy for SSH. It sits between SSH clients and
        servers, routing connections to different upstream servers based on
        username, public key, or other criteria. All SSH features are
        supported, including shell access, scp, port forwarding, and SFTP.
        Routing is handled by plugins such as yaml, workingdir, or lua.
      '';
      homepage = "https://github.com/tg123/sshpiper";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ cashmeredev ];
      mainProgram = "sshpiperd";
      platforms = lib.platforms.linux;
    };
  }
)
