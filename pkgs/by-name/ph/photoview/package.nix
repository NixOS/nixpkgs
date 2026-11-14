{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
  pkg-config,
  # Native dependencies for image processing and face recognition
  dlib,
  libjpeg,
  libheif,
  blas,
  lapack,
  # Runtime dependencies
  exiftool,
  darktable,
  ffmpeg,
}:

buildGoModule (finalAttrs: {
  pname = "photoview";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "photoview";
    repo = "photoview";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZfvBdQlyqONsrviZGL22Kt+AiPaVWwdoREDUrHDYyIs=";
  };

  vendorHash = "sha256-Tn4OxSV41s/4n2Q3teJRJNc39s6eKW4xE9wW/CIR5Fg=";

  modRoot = "api";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    dlib
    libjpeg
    libheif
    blas
    lapack
  ];

  postInstall = ''
    # Install face recognition models
    mkdir -p $out/share/photoview
    cp -r ${finalAttrs.src}/api/data $out/share/photoview/

    # Symlink the UI
    ln -s ${finalAttrs.passthru.ui} $out/share/photoview/ui

    # Rename binary and wrap with runtime dependencies
    mv $out/bin/api $out/bin/photoview
    wrapProgram $out/bin/photoview \
      --set PHOTOVIEW_FACE_RECOGNITION_MODELS_PATH $out/share/photoview/data/models \
      --set PHOTOVIEW_UI_PATH $out/share/photoview/ui \
      --set PHOTOVIEW_SERVE_UI 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          exiftool
          darktable
          ffmpeg
        ]
      }
  '';

  passthru.ui = callPackage ./ui.nix { inherit (finalAttrs) src version; };

  meta = {
    description = "Photo gallery for self-hosted personal servers";
    homepage = "https://photoview.github.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nettika ];
    mainProgram = "photoview";
    platforms = lib.platforms.linux;
  };
})
