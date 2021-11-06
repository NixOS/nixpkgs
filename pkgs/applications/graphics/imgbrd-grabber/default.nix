{ lib, stdenv
, cmake
, fetchFromGitHub
, wrapQtAppsHook
, qscintilla
, qtnetworkauth
, qtmultimedia
, qttools
, qtscript
, qtdeclarative
, qtbase
, autogen
, automake
, makeWrapper
, catch2
, nodejs
, libpulseaudio
, openssl
, rsync
, typescript
}:

stdenv.mkDerivation rec {
  pname = "imgbrd-grabber";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "Bionus";
    repo = "imgbrd-grabber";
    rev = "v${version}";
    sha256 = "06vgkwpk951fywwfcsw6p3nqsaa7yiaxfi5nrbd6z9y0vifgln90";
    fetchSubmodules = true;
  };

  buildInputs = [
    openssl
    makeWrapper
    libpulseaudio
    typescript
  ];

  nativeBuildInputs = [
    # This causes a segfault for reasons unknown, leave it disabled for now
    # qscintilla
    qtnetworkauth
    qtmultimedia
    qtbase
    qtdeclarative
    qttools
    nodejs
    cmake
    wrapQtAppsHook
  ];

  extraOutputsToLink = [ "doc" ];

  patches = [ ./variableToString-instantiation.patch ];

  postPatch = ''
    # the npm build step only runs typescript
    # run this step directly so it doesn't try and fail to download the unnecessary node_modules, etc.
    substituteInPlace ./sites/CMakeLists.txt --replace "npm install" "npm run build"

    # remove the vendored catch2
    rm -rf tests/src/vendor/catch

    # link the catch2 sources from nixpkgs
    ln -sf ${catch2.src} tests/src/vendor/catch

    # With recently released TypeScript v4.4, catch variables are now of type
    # 'unknown' instead of 'any'.
    for f in sites/*/*.ts ; do
      substituteInPlace "$f" --replace "catch (e)" "catch (e: any)"
    done
  '';

  postInstall = ''
    # move the binaries to the share/Grabber folder so
    # some relative links can be resolved (e.g. settings.ini)
    mv $out/bin/* $out/share/Grabber/

    cd ../..
    # run the package.sh with $out/share/Grabber as the $APP_DIR
    sh ./scripts/package.sh $out/share/Grabber

    # add symlinks for the binaries to $out/bin
    ln -s $out/share/Grabber/Grabber $out/bin/Grabber
    ln -s $out/share/Grabber/Grabber-cli $out/bin/Grabber-cli
  '';

  sourceRoot = "source/src";

  meta = with lib; {
    description = "Very customizable imageboard/booru downloader with powerful filenaming features";
    license = licenses.asl20;
    homepage = "https://bionus.github.io/imgbrd-grabber/";
    maintainers = with maintainers; [ evanjs interruptinuse ];
  };
}
