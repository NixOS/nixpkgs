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
  version = "2.32.0";

  pnpm = pnpm_9;
  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-jckwk45pIRrlzZaG3jH8aLq08L5xnrbt4OdwKNS6+nI=";
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
      hash = "sha256-L3cKAp0vvLW5QPz6vYTtZwzuIN70EObU3SyJOlA0Ehc=";
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

  vendorHash = "sha256-Jce90mvNzjElCtEMQSSU3IQPz+WLhyEol1ktW4FG7yk=";

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
