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
  version = "2.61.2";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-/8bBYRzWJ00FpcLMB8M6hkyMUEM/0PM8jsvR+m7jfpc=";
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
      hash = "sha256-2e3Gr5/pdOsT3cSTdOz5mAjZaWB1C3qGDikpoa5BoII=";
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

  vendorHash = "sha256-aY3OIr0Kbno38Y/PZ03JK5wCCD4HRdnznJ3OaaH/WVA=";

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

  meta = {
    description = "Web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
