{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs-slim,
  pnpm_10,
  nix-update-script,
  nixosTests,
}:

let
  version = "2.63.17";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    tag = "v${version}";
    hash = "sha256-zaePqJUCDgYb4/aUxryS1mBC+6GgpGsed+95YKxzxfY=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = [
      nodejs-slim
      pnpmConfigHook
      pnpmBuildHook
      pnpm_10
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      pnpm = pnpm_10;
      hash = "sha256-UwTA7Eogp2GrvmXDbdfGBTJS3DuOTJ42e6fHlQxSHoA=";
    };

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  });

in
buildGoModule {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-WXbXD75acK4woS7UC0G73pY48aGmp1l0spDc3sGYXMg=";

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
    changelog = "https://github.com/filebrowser/filebrowser/releases/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
