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
  fetchurl,
}:

let
  version = "261007-65faaae5d";
  pname = "photoprism";

  src = fetchFromGitHub {
    owner = "photoprism";
    repo = "photoprism";
    tag = version;
    hash = "sha256-cn+Xs4MYpvlOkrrSbYSoHuBgCfmdBDvKyRX1ovj4ppk=";
  };

  backend = callPackage ./backend.nix { inherit src version; };
  frontend = callPackage ./frontend.nix { inherit src version; };
  onnxruntime = callPackage ./onnxruntime.nix { };

  fetchModel =
    { name, hash }:
    fetchzip {
      inherit hash;
      extension = "zip";
      url = "https://dl.photoprism.app/tensorflow/${name}.zip?${version}";
      stripRoot = false;
    };

  fetchOnnxModel =
    { name, hash }:
    {
      inherit name;
      file = fetchurl {
        inherit hash;
        url = "https://dl.photoprism.app/onnx/models/${name}?${version}";
      };
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

  efficientformerv2_s2 = fetchOnnxModel {
    name = "efficientformerv2_s2.onnx";
    hash = "sha256-fWKIrYlHPCuhGXTJwkqW4HxOPuSMUxCB8QimOA3I0Ks=";
  };

  facenet = fetchModel {
    name = "facenet";
    hash = "sha256-aS5kkNhxOLSLTH/ipxg7NAa1w9X8iiG78jmloR1hpRo=";
  };

  sface = fetchOnnxModel {
    name = "face_recognition_sface_2021dec.onnx";
    hash = "sha256-C6n7+gG1JwyWYnxO94TahZkx4C8EQZyCnoNIQIfDTnk=";
  };

  yahoo_open_nsfw = fetchOnnxModel {
    name = "yahoo_open_nsfw.onnx";
    hash = "sha256-dD3ewLjWpu6RL1K0c32B9NHlHlytAfI4T2ffCk04S5c=";
  };

  yunet = fetchOnnxModel {
    name = "face_detection_yunet_2026may.onnx";
    hash = "sha256-66/OTjwRjWVUY0vlwnqzM7TAR6mow/rx18+TEBwi8PA=";
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
    # NB: this must be a copy not a symlink, photoprism looks for onnxruntime
    # relative to its binary, and if we use a symlink we'd have to link the library
    # in with the backend derivation itself
    cp ${backend}/bin/photoprism $out/bin/photoprism
    ln -s ${onnxruntime}/lib $out/lib
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
    mkdir -p ${assets_path}/models/{efficientformerv2_s2,sface,yahoo_open_nsfw,yunet}
    ln -s ${frontend}/assets/models/* ${assets_path}/models/

    # install tensorflow models
    ln -s ${facenet}/facenet ${assets_path}/models/

    # install onnx models
    ln -s ${efficientformerv2_s2.file} ${assets_path}/models/efficientformerv2_s2/${efficientformerv2_s2.name}
    ln -s ${sface.file} ${assets_path}/models/sface/${sface.name}
    ln -s ${yahoo_open_nsfw.file} ${assets_path}/models/yahoo_open_nsfw/${yahoo_open_nsfw.name}
    ln -s ${yunet.file} ${assets_path}/models/yunet/${yunet.name}

    runHook postInstall
  '';

  passthru = {
    inherit backend frontend onnxruntime;

    facenet = wrapModelForUpdate facenet;
    efficientformerv2_s2 = wrapModelForUpdate efficientformerv2_s2;
    yahoo_open_nsfw = wrapModelForUpdate yahoo_open_nsfw;
    sface = wrapModelForUpdate sface.file;
    yunet = wrapModelForUpdate yunet.file;

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
        "efficientformerv2_s2"
        "--subpackage"
        "facenet"
        "--subpackage"
        "onnxruntime"
        "--subpackage"
        "sface"
        "--subpackage"
        "yahoo_open_nsfw"
        "--subpackage"
        "yunet"
      ];
    };
  };

  meta = {
    homepage = "https://photoprism.app";
    description = "Personal Photo Management powered by Go and Google TensorFlow";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
    mainProgram = "photoprism";
  };
})
