{ stdenv
, fetchFromGitHub
, pantheon
, cmake
, pkg-config
, vala
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "agenda";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "dahenson";
    repo = pname;
    rev = version;
    sha256 = "128c9p2jkc90imlq25xg5alqlam8q4i3gd5p1kcggf7s4amv8l8w";
  };

  nativeBuildInputs = [
    cmake
    gettext
    vala
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple, fast, no-nonsense to-do (task) list designed for elementary OS";
    homepage = https://github.com/dahenson/agenda;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

