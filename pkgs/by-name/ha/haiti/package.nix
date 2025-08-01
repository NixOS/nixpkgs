{
  fetchFromGitHub,
  lib,
  makeWrapper,
  ruby,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haiti";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "noraj";
    repo = "haiti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1PGGlnbw8zg2sNEc85Un7no7elS5aPSfjzfmqovmiHk=";
  };

  nativeBuildInputs = [
    makeWrapper
    ruby
  ];

  paintSrc = fetchFromGitHub {
    owner = "janlelis";
    repo = "paint";
    rev = "7076784c5d57f178690d19e4f8644441ff73f518";
    hash = "sha256-uITUfcZjOACeCGsozpUxAYd98Y9oFTgyXems2Q3aYRU=";
  };

  docoptSrc = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.rb";
    rev = "794c47d7cb62ca71d65086623a55881449bc2f9e";
    hash = "sha256-9DbKTPsZRRAqDkN2wMzBtbbtyKDcVSGmVDcekf4WBnw=";
  };

  buildPhase = ''
    runHook preBuild

    paintBuild=$(mktemp -d)
    cp -r ${finalAttrs.paintSrc}/* $paintBuild
    pushd $paintBuild
      sed -i '/.github/d' paint.gemspec
      sed -i '/.rspec/d' paint.gemspec
      gem build -V paint.gemspec
    popd
    paintGem=$paintBuild/paint-2.3.0.gem

    docoptBuild=$(mktemp -d)
    cp -r ${finalAttrs.docoptSrc}/* $docoptBuild
    pushd $docoptBuild
      gem build -V docopt.gemspec
    popd
    docoptGem=$docoptBuild/docopt-0.6.1.gem

    gem build -V haiti.gemspec

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gem install -V $paintGem $docoptGem haiti-hash-${finalAttrs.version}.gem \
    --install-dir=$out/lib \
    --ignore-dependencies

    for i in $out/lib/bin/*;
    do
      filename=$(basename $i)
      makeWrapper ${lib.getExe ruby} $out/bin/$filename \
      --set GEM_PATH $out/lib \
      --add-flags $out/lib/bin/$filename
    done

    rm -rf $out/lib/{build_info,cache,doc,extensions,plugins}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/noraj/haiti/releases/tag/v${finalAttrs.version}";
    description = "CLI tool to identify hash types";
    homepage = "https://github.com/noraj/haiti";
    license = lib.licenses.mit;
    mainProgram = "haiti";
    maintainers = with lib.maintainers; [ KSJ2000 ];
    platforms = lib.platforms.unix;
  };
})
