{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  python3,
  hwdata,
  edid-decode,
}:

stdenv.mkDerivation rec {
  pname = "libdisplay-info";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = pname;
    rev = version;
    sha256 = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    edid-decode
    hwdata
    python3
  ];

  postPatch = ''
    patchShebangs tool/gen-search-table.py
  '';

  meta = with lib; {
    description = "EDID and DisplayID library";
    mainProgram = "di-edid-decode";
    homepage = "https://gitlab.freedesktop.org/emersion/libdisplay-info";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pedrohlc ];
  };
}
