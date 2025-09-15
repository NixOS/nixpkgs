{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  dart-sass,
  nix-update-script,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "homer";
  version = "25.08.1";
  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-DA2gdh6o67QDC4y+N5DVG0ktjt/ORNbycU/y2cUjUE0=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit
      pname
      version
      src
      patches
      ;
    fetcherVersion = 2;
    hash = "sha256-y/4f/39NOVV46Eg3h7fw8K43/kUIBqtiokTRRlX7398=";
  };

  # Enables specifying a custom Sass compiler binary path via `SASS_EMBEDDED_BIN_PATH` environment variable.
  patches = [ ./0001-build-enable-specifying-custom-sass-compiler-path-by.patch ];

  nativeBuildInputs = [
    nodejs
    dart-sass
    pnpm_10.configHook
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

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests.homer) caddy nginx;
    };
  };

  meta = with lib; {
    description = "Very simple static homepage for your server";
    homepage = "https://github.com/bastienwirtz/homer";
    changelog = "https://github.com/bastienwirtz/homer/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [
      stunkymonkey
      christoph-heiss
    ];
    platforms = platforms.all;
  };
}
