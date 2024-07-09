{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  makeWrapper,
  catch2,
  nodejs,
  libpulseaudio,
  openssl,
  rsync,
  typescript,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "imgbrd-grabber";
  version = "7.12.2";

  src = fetchFromGitHub {
    owner = "Bionus";
    repo = "imgbrd-grabber";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6XfIaASfbvdPovtdDEJtsk4pEL4Dhmyq8ml4X7KZ4DE=";
    fetchSubmodules = true;
  };

  buildInputs =
    with qt6;
    [
      qtbase
      qtdeclarative
      qttools
      qtnetworkauth
      qtmultimedia
    ]
    ++ [
      openssl
      libpulseaudio
      typescript
      nodejs
    ];

  nativeBuildInputs = [
    makeWrapper
    qt6.wrapQtAppsHook
    cmake
  ];

  extraOutputsToLink = [ "doc" ];

  preBuild = ''
    export HOME=$TMPDIR

    # the package.sh script provides some install helpers
    # using this might make it easier to maintain/less likely for the
    # install phase to fail across version bumps
    patchShebangs ../scripts/package.sh
  '';

  postPatch = ''

    # ensure the script uses the rsync package from nixpkgs
    substituteInPlace ../scripts/package.sh --replace-fail "rsync" "${lib.getExe rsync}"


    # the npm build step only runs typescript
    # run this step directly so it doesn't try and fail to download the unnecessary node_modules, etc.
    substituteInPlace ./sites/CMakeLists.txt --replace-fail "npm install" "npm run build"

    # link the catch2 sources from nixpkgs
    ln -sf ${catch2.src} tests/src/
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

  sourceRoot = "${finalAttrs.src.name}/src";

  meta = {
    description = "Very customizable imageboard/booru downloader with powerful filenaming features";
    license = lib.licenses.asl20;
    homepage = "https://bionus.github.io/imgbrd-grabber/";
    mainProgram = "Grabber";
    maintainers = with lib.maintainers; [
      evanjs
      luftmensch-luftmensch
    ];
  };
})
