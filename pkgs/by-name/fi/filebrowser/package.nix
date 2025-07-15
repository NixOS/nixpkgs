{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo123Module,

  nodejs_22,
  pnpm_9,

  nixosTests,
}:

let
  version = "2.36.0";

  pnpm = pnpm_9;
  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-t3e4DBxGc3KWeNyqZrQRtySfECc+/lSZJFtOXTUPNk8=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "filebrowser-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmRoot = "frontend";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${src.name}/frontend";
      fetcherVersion = 1;
      hash = "sha256-vLOtVeGFeHXgQglvKsih4lj1uIs6wipwfo374viIq4I=";
    };

    installPhase = ''
      runHook preInstall

      pnpm install -C frontend --frozen-lockfile
      pnpm run -C frontend build

      mkdir $out
      mv frontend/dist $out

      runHook postInstall
    '';
  });

in
buildGo123Module {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-u5ybdo4Xe0ZIP90BymsdTxmCjoR4Mki+lYlp1wP+yrU=";

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  ldflags = [
    "-X github.com/filebrowser/filebrowser/v2/version.Version=v${version}"
  ];

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) filebrowser;
    };
  };

  meta = with lib; {
    description = "Filebrowser is a web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
