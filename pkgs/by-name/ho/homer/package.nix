{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  dart-sass,
  nix-update-script,
  nixosTests,
}:
stdenvNoCC.mkDerivation rec {
  pname = "homer";
  version = "25.02.1";
  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-Fh6qV2eU7VRskbPun7OcJmqgjILVE8w5lV70xH6znmc=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      pname
      version
      src
      patches
      ;
    hash = "sha256-qeMmPI2B5FW82qLVtbREDjQh76THMCOZRQCM0DgvCqI=";
  };

  # Enables specifying a custom Sass compiler binary path via `SASS_EMBEDDED_BIN_PATH` environment variable.
  patches = [ ./0001-build-enable-specifying-custom-sass-compiler-path-by.patch ];

  nativeBuildInputs = [
    nodejs
    dart-sass
    pnpm_9.configHook
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
    description = "A very simple static homepage for your server.";
    homepage = "https://homer-demo.netlify.app/";
    changelog = "https://github.com/bastienwirtz/homer/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [
      stunkymonkey
      christoph-heiss
    ];
    platforms = platforms.all;
  };
}
