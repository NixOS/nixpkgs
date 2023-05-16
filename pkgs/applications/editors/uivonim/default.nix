<<<<<<< HEAD
{ lib
, buildNpmPackage
, fetchFromGitHub
, electron
, makeWrapper
}:

buildNpmPackage rec {
  pname = "uivonim";
  version = "0.29.0";
=======
{ lib, mkYarnPackage, fetchFromGitHub, electron, makeWrapper }:

mkYarnPackage rec {
  pname = "uivonim";
  version = "unstable-2021-05-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "smolck";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-TcsKjRwiCTRQLxolRuJ7nRTGxFC0V2Q8LQC5p9iXaaY=";
  };

  npmDepsHash = "sha256-jWLvsN6BCxTWn/Lc0fSz0VJIUiFNN8ptSYMeWlWsHXc=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build:prod";
=======
    rev = "ac027b4575b7e1adbedde1e27e44240289eebe39";
    sha256 = "1b6k834qan8vhcdqmrs68pbvh4b59g9bx5126k5hjha6v3asd8pj";
  };

  # The spectron dependency has to be removed manually from package.json,
  # because it requires electron-chromedriver, which wants to download stuff.
  # It is also good to remove the electron-builder bloat.
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  yarnPreBuild = ''
    # workaround for missing opencollective-postinstall
    mkdir -p $TMPDIR/bin
    touch $TMPDIR/bin/opencollective-postinstall
    chmod +x $TMPDIR/bin/opencollective-postinstall
    export PATH=$PATH:$TMPDIR/bin

    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
  '';

  # We build (= webpack) uivonim in a separate package,
  # because this requires devDependencies that we do not
  # wish to bundle (because they add 250M to the closure size).
  build = mkYarnPackage {
    name = "uivonim-build-${version}";
    inherit version src packageJSON yarnLock yarnNix yarnPreBuild distPhase;

    buildPhase = ''
      yarn build:prod
    '';

    installPhase = ''
      mv deps/uivonim/build $out
    '';
  };

  # The --production flag disables the devDependencies.
  yarnFlags = [ "--production" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
<<<<<<< HEAD
    makeWrapper ${electron}/bin/electron $out/bin/uivonim \
      --add-flags $out/lib/node_modules/uivonim/build/main/main.js
  '';

=======
    dir=$out/libexec/uivonim/node_modules/uivonim/
    # need to copy instead of symlink because
    # otherwise electron won't find the node_modules
    cp -ra ${build} $dir/build
    makeWrapper ${electron}/bin/electron $out/bin/uivonim \
      --set NODE_ENV production \
      --add-flags $dir/build/main/main.js
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/smolck/uivonim";
    description = "Cross-platform GUI for neovim based on electron";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
}
