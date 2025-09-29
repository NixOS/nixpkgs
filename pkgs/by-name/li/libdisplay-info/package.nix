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

stdenv.mkDerivation rec {
  pname = "libdisplay-info";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "libdisplay-info";
    rev = version;
    sha256 = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
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
}
