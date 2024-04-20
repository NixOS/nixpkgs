{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fftw
, krita
, libsForQt5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krita-plugin-gmic";
  version = "3.2.4.1";

  src = fetchFromGitHub {
    owner = "amyspark";
    repo = "gmic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SYE8kGvN7iD5OqiEEZpB/eRle67PrB5DojMC79qAQtg=";
  };
  sourceRoot = "${finalAttrs.src.name}/gmic-qt";
  dontWrapQtApps = true;

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    fftw
    krita.unwrapped
    libsForQt5.kcoreaddons
    libsForQt5.qttools
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GMIC_QT_HOST" "krita-plugin")
    # build krita's gmic instead of using the one from nixpkgs
    (lib.cmakeBool "ENABLE_SYSTEM_GMIC" false)
  ];

  meta = with lib; {
    homepage = "https://github.com/amyspark/gmic";
    description = "GMic plugin for Krita";
    license = lib.licenses.cecill21;
    maintainers = with maintainers; [ lelgenio ];
  };
})
