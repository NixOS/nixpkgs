{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  wrapQtAppsHook,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "rclone-browser";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kapitainsky";
    repo = "RcloneBrowser";
    tag = version;
    hash = "sha256-Y0QFzpvAV01k9fYN5iMpxd8A+ThLePDtxdG7eX2bk5E=";
  };

  patches = [
    # patch for Qt 5.15, https://github.com/kapitainsky/RcloneBrowser/pull/126
    (fetchpatch {
      url = "https://github.com/kapitainsky/RcloneBrowser/commit/ce9cf52e9c584a2cc85a5fa814b0fd7fa9cf0152.patch";
      hash = "sha256-iAEeYDqW//CvSsu7j0B+aLMeIgr3NiKT2vVgVakTpFo=";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.10" ];

  buildInputs = [ qtbase ];

  meta = {
    changelog = "https://github.com/kapitainsky/RcloneBrowser/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/kapitainsky/RcloneBrowser";
    description = "Graphical Frontend to Rclone written in Qt";
    mainProgram = "rclone-browser";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
