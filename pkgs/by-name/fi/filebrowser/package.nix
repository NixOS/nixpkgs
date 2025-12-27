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
  version = "2.52.0";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-SnA7A9wnWyX+m+HPkpaASLw+FvZZWkv28AvBF2bJNLA=";
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
      hash = "sha256-x3K1iwd+SkWx3MdlQWOh/oy1h9Xwk7iqbSmAepJ75eY=";
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

  vendorHash = "sha256-DY+Dbbawe2CSvvW48NwrnuhxrEFObkDNfVdu9Q8oJOo=";

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
