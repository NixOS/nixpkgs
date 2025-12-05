{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  pnpm_9,
  nix-update-script,
  nixosTests,
}:
let
  version = "2.44.1";

  pnpm = pnpm_9;

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-ln7Dst+sN99c3snPU7DrIGpwKBz/e4Lz+uOknmm6sxg=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmConfigHook = pnpm.configHook;
    npmDeps = pnpmDeps;

    pnpmDeps = pnpm.fetchDeps {
      inherit
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 2;
      hash = "sha256-3n44BGJLdQR6uBSF09oyUzJm35/S3/ZEyZh4Wxqlfiw=";
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

  vendorHash = "sha256-aVtL64Cm+nqum/qHFvplpEawgMXM2S6l8QFrJBzLVtU=";

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  ldflags = [
    "-X github.com/filebrowser/filebrowser/v2/version.Version=v${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    inherit frontend;
    tests = {
      inherit (nixosTests) filebrowser;
    };
  };

  meta = with lib; {
    description = "Web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
