{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, python3
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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dahenson";
    repo = pname;
    rev = version;
    sha256 = "0yfapapsanqacaa83iagar88i335yy2jvay8y6z7gkri7avbs4am";
  };

  nativeBuildInputs = [
    gettext
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple, fast, no-nonsense to-do (task) list designed for elementary OS";
    homepage = "https://github.com/dahenson/agenda";
    maintainers = with maintainers; [ xiorcale ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

