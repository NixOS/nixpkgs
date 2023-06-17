{
  src,
  version,
  lib,
  buildGoModule,
  makeWrapper,
  dlib,
  libjpeg,
  libheif,
  blas,
  lapack,
  exiftool,
  pkg-config,
}:
buildGoModule {
  pname = "photoview-backend";
  inherit version;

  src = src + "/api/";

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

  vendorHash = "sha256-0SWywy9YdPtgvxRhwKhKvspPmhbnibSuhvzhsjIQvZk=";

  postInstall = ''
    mkdir -p $out/share/photoview
    cp -R data $out/share/photoview/
  '';

  postFixup = ''
    wrapProgram $out/bin/api \
      --set PHOTOVIEW_FACE_RECOGNITION_MODELS_PATH $out/share/photoview/data/models \
      --set PATH ${lib.makeBinPath [ exiftool ]}
  '';
}
