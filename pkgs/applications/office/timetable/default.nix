{ stdenv
, fetchFromGitHub
, glib
, gtk3
, hicolor-icon-theme
, json-glib
, libgee
, meson
, ninja
, pkgconfig
, pantheon
, python3
, wrapGAppsHook
}:


stdenv.mkDerivation rec {
  pname = "timetable";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "0s825al10s0hwfzl90bplwwasx89wx28n41sg2md71l9hfqy296q";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    pantheon.vala
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    hicolor-icon-theme
    json-glib
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Plot out your own timetable for the week and organize it";
    homepage = "https://github.com/lainsce/timetable";
    maintainers = [ maintainers.kjuvi ] ++ pantheon.maintainers;
    license = licenses.gpl2Plus;
  };
}
