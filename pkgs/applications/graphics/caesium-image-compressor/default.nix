{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, cmake
, qtbase
, qtsvg
, qttools
, libcaesium
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caesium-image-compressor";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "Lymphatus";
    repo = "caesium-image-compressor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TbhcGGS22wfN47R78Ns2Nct8w7haMCNDatG8NXRXeK4=";
  };

  patches = [
    # Fix finding libcaesium
    # https://github.com/Lymphatus/caesium-image-compressor/pull/206
    (fetchpatch {
      url = "https://github.com/Lymphatus/caesium-image-compressor/commit/4293296340e0bd497d26d9420d00f39c30b0e9e6.patch";
      hash = "sha256-vJl/JznSm8oUYcOIFMf6/+1R1s39C8TPjuX0q92SDcU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libcaesium
    qtbase
    qtsvg
    qttools
  ];

  meta = with lib; {
    description = "Reduce file size while preserving the overall quality of the image";
    homepage = "https://github.com/Lymphatus/caesium-image-compressor";
    mainProgram = "caesium-image-compressor";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
})
