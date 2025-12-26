{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  python3,
  hwdata,
  v4l-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdisplay-info";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "libdisplay-info";
    rev = finalAttrs.version;
    sha256 = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    v4l-utils
    hwdata
    python3
  ];

  postPatch = ''
    patchShebangs tool/gen-search-table.py
  '';

  meta = {
    description = "EDID and DisplayID library";
    mainProgram = "di-edid-decode";
    homepage = "https://gitlab.freedesktop.org/emersion/libdisplay-info";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pedrohlc ];
  };
})
