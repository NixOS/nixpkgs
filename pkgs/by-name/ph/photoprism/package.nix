{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  darktable,
  rawtherapee,
  ffmpeg,
  libheif,
  exiftool,
  imagemagick,
  makeWrapper,
  testers,
  callPackage,
  nixosTests,
  librsvg,
  nix-update-script,
}:

let
  version = "260728-bbde8f452";
  pname = "photoprism";

  src = fetchFromGitHub {
    owner = "photoprism";
    repo = "photoprism";
    rev = version;
    hash = "sha256-NRVaTrYrYpOdeNLM+GY6Ae7jXR3uNpAVjhLWWoHCdyc=";
  };

  backend = callPackage ./backend.nix { inherit src version; };
  frontend = callPackage ./frontend.nix { inherit src version; };

  fetchModel =
    { name, hash }:
    fetchzip {
      inherit hash;
      extension = "zip";
      url = "https://dl.photoprism.app/tensorflow/${name}.zip?${version}";
      stripRoot = false;
    };

  # NB: needs to be a derivation with a src attribute so the update script
  # can ensure that these hashes remain up to date
  wrapModelForUpdate =
    src:
    stdenv.mkDerivation {
      inherit pname version src;

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        mkdir $out
      '';

      passthru.updateScript = nix-update-script { };
    };

  facenet = fetchModel {
    name = "facenet";
    hash = "sha256-aS5kkNhxOLSLTH/ipxg7NAa1w9X8iiG78jmloR1hpRo=";
  };

  nasnet = fetchModel {
    name = "nasnet";
    hash = "sha256-bF25jPmZLyeSWy/CGXZE/VE2UupEG2q9Jmr0+1rUYWE=";
  };

  nsfw = fetchModel {
    name = "nsfw";
    hash = "sha256-zy/HcmgaHOY7FfJUY6I/yjjsMPHR2Ote9ppwqemBlfg=";
  };

  assets_path = "$out/share/photoprism";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin ${assets_path}

    # install backend
    ln -s ${backend}/bin/photoprism $out/bin/photoprism
    wrapProgram $out/bin/photoprism \
      --set PHOTOPRISM_ASSETS_PATH ${assets_path} \
      --set PHOTOPRISM_DARKTABLE_BIN ${darktable}/bin/darktable-cli \
      --set PHOTOPRISM_RAWTHERAPEE_BIN ${rawtherapee}/bin/rawtherapee-cli \
      --set PHOTOPRISM_HEIFCONVERT_BIN ${libheif}/bin/heif-dec \
      --set PHOTOPRISM_RSVGCONVERT_BIN ${librsvg}/bin/rsvg-convert \
      --set PHOTOPRISM_FFMPEG_BIN ${ffmpeg}/bin/ffmpeg \
      --set PHOTOPRISM_EXIFTOOL_BIN ${exiftool}/bin/exiftool \
      --set PHOTOPRISM_IMAGEMAGICK_BIN ${imagemagick}/bin/convert

    # install frontend
    ln -s ${frontend}/assets/* ${assets_path}
    rm ${assets_path}/models
    mkdir -p ${assets_path}/models
    ln -s ${frontend}/assets/models/* ${assets_path}/models/

    # install tensorflow models
    ln -s ${nasnet}/nasnet ${assets_path}/models/
    ln -s ${nsfw}/nsfw ${assets_path}/models/
    ln -s ${facenet}/facenet ${assets_path}/models/

    runHook postInstall
  '';

  passthru = {
    inherit backend frontend;

    facenet = wrapModelForUpdate facenet;
    nasnet = wrapModelForUpdate nasnet;
    nsfw = wrapModelForUpdate nsfw;

    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      photoprism = nixosTests.photoprism;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "backend"
        "--subpackage"
        "frontend"
        "--subpackage"
        "facenet"
        "--subpackage"
        "nasnet"
        "--subpackage"
        "nsfw"
      ];
    };
  };

  meta = {
    homepage = "https://photoprism.app";
    description = "Personal Photo Management powered by Go and Google TensorFlow";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
    mainProgram = "photoprism";
  };
})
