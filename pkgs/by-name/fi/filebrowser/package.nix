{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_24,
  pnpm_10,
  nix-update-script,
  nixosTests,
}:

let
  version = "2.63.3";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-v3cC8opClvt91MqUIKNZdvCv0hPeCvWPi0IlOMHlWbQ=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = [ pnpm_10 ];
    npmConfigHook = pnpmConfigHook;
    npmDeps = pnpmDeps;
    nodejs = nodejs_24;

    pnpmDeps = fetchPnpmDeps {
      inherit
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      pnpm = pnpm_10;
      hash = "sha256-g8BWDEymQNOkLYBws0ii4iLnpjB7X4EQl0OzR3GXeq0=";
    };

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  };

in
buildGoModule {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-ofeQkbvBfCpu2g1CLAwUZAZISyAOz+0smEZRx/koj/8=";

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  ldflags = [
    "-X github.com/filebrowser/filebrowser/v2/version.Version=v${version}"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
    inherit frontend;
    tests = {
      inherit (nixosTests) filebrowser;
    };
  };

  meta = {
    description = "Web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
