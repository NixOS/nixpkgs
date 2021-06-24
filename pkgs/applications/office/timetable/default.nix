{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, glib
, gtk3
, vala
, json-glib
, libgee
, meson
, ninja
, pkg-config
, pantheon
, python3
, wrapGAppsHook
}:


stdenv.mkDerivation rec {
  pname = "timetable";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "12c8kdrbz6x2mlrvr0nq9y5khj0qiiwlxf7aqc2z3dnrawjgy1rb";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Plot out your own timetable for the week and organize it";
    homepage = "https://github.com/lainsce/timetable";
    maintainers = [ maintainers.xiorcale ] ++ pantheon.maintainers;
    license = licenses.gpl2Plus;
  };
}
