{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  dart-sass,
  nix-update-script,
  nixosTests,
}:
stdenvNoCC.mkDerivation rec {
  pname = "homer";
  version = "25.11.1";
  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-6shFVaCtPQeZCeeswAQHgcXOwVwABNa3ljsdUG63QGo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-TtazfRhcniA1H//C95AMH8/Pw+Rbtinlfg7dDAmSk1w=";
  };

  nativeBuildInputs = [
    nodejs
    dart-sass
    pnpmConfigHook
    pnpm_10
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

  meta = {
    description = "Very simple static homepage for your server";
    homepage = "https://github.com/bastienwirtz/homer";
    changelog = "https://github.com/bastienwirtz/homer/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      stunkymonkey
      christoph-heiss
    ];
    platforms = lib.platforms.all;
  };
}
