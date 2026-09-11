{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  imagemagick,
}:

stdenv.mkDerivation {
  pname = "celestia-content";
  version = "0-unstable-2026-07-19";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CelestiaProject";
    repo = "CelestiaContent";
    rev = "724b9545b72c56c1a9afeda35d48f611e4f0d20f";
    hash = "sha256-4wicyDIvBK3gD6pAgFO0YH5gRT8E7/g9Qr3YDbRKHVw=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    imagemagick
  ];

  meta = {
    description = "Data files for Celestia space simulator";
    maintainers = with lib.maintainers; [ pancaek ];
    license =
      with lib.licenses;
      AND [
        cc-by-30
        cc-by-40
        cc-by-nc-sa-30
        # (unused according to upstream CI, at least for now)
        # cc-by-sa-30
        cc-by-sa-40
        cc0
        gpl2Plus
        jpl-image
        cc-by-nc-30-igo
        # some files are unlicensed so far, so to be safe let's mark unfree also
        unfree
      ];
  };
}
