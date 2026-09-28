{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  cmake,
  qt6,
  mupdf,
  harfbuzz,
  freetype,
  libjpeg,
  openjpeg,
  gumbo,
  mujs,
  onnxruntime,
  useModelScope ? true,
  ...
}:

let
  baseUrl =
    if useModelScope then
      "https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.8.0/onnx/PP-OCRv5/rec"
    else
      "https://huggingface.co/RapidAI/RapidOCR/resolve/v3.8.0/onnx/PP-OCRv5/rec";
  ocr_models = {
    latin_rec = fetchurl {
      url = "${baseUrl}/latin_PP-OCRv5_rec_mobile.onnx";
      sha256 = "b20bd37c168a570f583afbc8cd7925603890efbcdc000a59e22c269d160b5f5a";
    };
    ch_rec = fetchurl {
      url = "${baseUrl}/ch_PP-OCRv5_rec_mobile.onnx";
      sha256 = "5825fc7ebf84ae7a412be049820b4d86d77620f204a041697b0494669b1742c5";
    };
    korean_rec = fetchurl {
      url = "${baseUrl}/korean_PP-OCRv5_rec_mobile.onnx";
      sha256 = "cd6e2ea50f6943ca7271eb8c56a877a5a90720b7047fe9c41a2e541a25773c9b";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "speedynote";
  version = "1.6.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alpha-liu-01";
    repo = "SpeedyNote";
    tag = "v${version}";
    sha256 = "sha256-2vaRmvkdu3sYIsMCwYxIfLdLpJykdwCZETraaTTEnic";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    mupdf
    harfbuzz
    freetype
    libjpeg
    openjpeg
    gumbo
    mujs
  ];

  patches = [
    ./dont-install-onnxruntime.patch
  ];

  preConfigure =
    let
      onnx_place = "linux/onnxruntime-build";
      model_place = "linux/ocr-models";
    in
    ''
      mkdir -p ${onnx_place}
      ln -s ${onnxruntime.dev}/include ${onnx_place}/include
      ln -s ${onnxruntime}/lib ${onnx_place}/lib

      mkdir -p ${model_place}
      cp ${ocr_models.latin_rec} ${model_place}/latin_rec.onnx
      cp ${ocr_models.ch_rec} ${model_place}/ch_rec.onnx
      cp ${ocr_models.korean_rec} ${model_place}/korean_rec.onnx
    '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    test -f "$out/share/speedynote/ocr-models/latin_rec.onnx"
    test -f "$out/share/speedynote/ocr-models/ch_rec.onnx"
    test -f "$out/share/speedynote/ocr-models/korean_rec.onnx"
  '';

  postFixup = ''
    real=$out/bin/.speedynote-wrapped
    [ -f "$real" ] || real=$out/bin/speedynote
    patchelf --add-rpath "${onnxruntime}/lib" $real
  '';

  meta = with lib; {
    description = "A simple note app with good performance and PDF import support";
    homepage = "https://github.com/alpha-liu-01/SpeedyNote";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "speedynote";
    maintainers = with lib.maintainers; [ sidbayeck ];
  };
}
