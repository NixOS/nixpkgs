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
  version = "2.42.5";

  pnpm = pnpm_9;

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-6AZwWdYQlaQ30Q5ohi9ovlUJZZ+u7Wqc5mfRW/3t7Zs=";
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
      hash = "sha256-uGEw6Wt6hXEcYQzXYzfgo3fcCX7Hj39bLHsT1rsGy74=";
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
