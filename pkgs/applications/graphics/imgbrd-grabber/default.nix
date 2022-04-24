{ lib, stdenv
, cmake
, fetchFromGitHub
, wrapQtAppsHook
, qtmultimedia
, qttools
, qtscript
, qtdeclarative
, qtnetworkauth
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
  version = "7.7.1";

  src = fetchFromGitHub {
    owner = "Bionus";
    repo = "imgbrd-grabber";
    rev = "v${version}";
    sha256 = "sha256-3qE3mdtlIlReIkUf0oH2/qmunE8nvdB0EaD7EOqaEj0=";
    fetchSubmodules = true;
  };

  buildInputs = [
    openssl
    libpulseaudio
    typescript
  ];

  nativeBuildInputs = [
    makeWrapper
    qtmultimedia
    qtbase
    qtdeclarative
    qttools
    qtnetworkauth
    nodejs
    cmake
    wrapQtAppsHook
  ];

  extraOutputsToLink = [ "doc" ];

  postPatch = ''
    # the package.sh script provides some install helpers
    # using this might make it easier to maintain/less likely for the
    # install phase to fail across version bumps
    patchShebangs ./scripts/package.sh

    # ensure the script uses the rsync package from nixpkgs
    substituteInPlace ../scripts/package.sh --replace "rsync" "${rsync}/bin/rsync"


    # the npm build step only runs typescript
    # run this step directly so it doesn't try and fail to download the unnecessary node_modules, etc.
    substituteInPlace ./sites/CMakeLists.txt --replace "npm install" "npm run build"

    # remove the vendored catch2
    rm -rf tests/src/vendor/catch

    # link the catch2 sources from nixpkgs
    ln -sf ${catch2.src} tests/src/vendor/catch

    sed "s|strict\": true|strict\": false|g" -i ./sites/tsconfig.json
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
    maintainers = [ maintainers.evanjs ];
  };
}
