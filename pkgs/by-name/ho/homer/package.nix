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
  version = "25.10.1";
  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-5OWfWey6pFn+XUv9cvGoXD6ExKKFHL7PMTqqce7C7Q8=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit
      pname
      version
      src

      ;
    fetcherVersion = 2;
    hash = "sha256-2cozIe70PGo1WRUeWrY8W1B6U2QYLbWYcwN5WllRwkg=";
  };

  nativeBuildInputs = [
    nodejs
    dart-sass
    pnpm_10.configHook
  ];

  buildPhase = ''
    runHook preBuild

    # force the sass npm dependency to use our own sass binary instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R dist/* $out/

    # Remove sample/demo files from output
    rm -f $out/assets/*.yml.dist
    rm -f $out/assets/*.css.sample

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
