{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "260919-28c46a116";
  pname = "photoprism";

  src = fetchFromGitHub {
    owner = "photoprism";
    repo = "photoprism";
    rev = version;
    hash = "sha256-+3zLhHTpNlDoYYD1ljDii/BhzP+72y+SCec7pa/1VNs=";
  };

  backend = callPackage ./backend.nix { inherit src version; };
  frontend = callPackage ./frontend.nix { inherit src version; };
  models = callPackage ./models.nix { inherit src version; };

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
    # install tensorflow models
    ln -s ${models} ${assets_path}/models

    runHook postInstall
  '';

  passthru = {
    inherit backend frontend models;

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
        "models"
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
