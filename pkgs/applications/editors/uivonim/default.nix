{ lib, mkYarnPackage, fetchFromGitHub, electron, makeWrapper }:

mkYarnPackage rec {
  pname = "uivonim";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "smolck";
    repo = pname;
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

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    dir=$out/libexec/uivonim/node_modules/uivonim/
    # need to copy instead of symlink because
    # otherwise electron won't find the node_modules
    cp -ra ${build} $dir/build
    makeWrapper ${electron}/bin/electron $out/bin/uivonim \
      --set NODE_ENV production \
      --add-flags $dir/build/main/main.js
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

  meta = with lib; {
    homepage = "https://github.com/smolck/uivonim";
    description = "Cross-platform GUI for neovim based on electron";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
}
