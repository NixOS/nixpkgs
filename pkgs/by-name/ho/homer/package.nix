{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
  dart-sass,
}:
stdenvNoCC.mkDerivation rec {
  pname = "homer";
  version = "24.11.4";
  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-UaoBdYzTEYB1pkiTYrt4T7GjwMJWXPuW5VSl4MU8DCI=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit
      pname
      version
      src
      patches
      ;
    hash = "sha256-5unoY8lPaX9sZAJEBICpxSddwLV8liK1tbamB2ulvew=";
  };

  # Enables specifying a custom Sass compiler binary path via `SASS_EMBEDDED_BIN_PATH` environment variable.
  patches = [ ./sass-embedded.patch ];

  nativeBuildInputs = [
    nodejs
    dart-sass
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild

    export SASS_EMBEDDED_BIN_PATH="${dart-sass}/bin/sass"
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A very simple static homepage for your server.";
    homepage = "https://homer-demo.netlify.app/";
    changelog = "https://github.com/bastienwirtz/homer/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.all;
  };
}
