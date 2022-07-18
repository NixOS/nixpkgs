{ lib, stdenv, fetchFromGitHub, nix-update-script
, vala, meson, ninja, pkg-config, pantheon, gettext, wrapGAppsHook, python3, desktop-file-utils
, gtk3, glib, libgee, libgda, gtksourceview, libxml2, libsecret, libssh2 }:


let
  sqlGda = libgda.override {
    mysqlSupport = true;
    postgresSupport = true;
  };

in stdenv.mkDerivation rec {
  pname = "sequeler";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MsHHTYERe0v+u3KnVtx+jmJTKORJTJ7bNfJMZHV9Ly4=";
  };

  nativeBuildInputs = [ meson ninja pkg-config vala gettext wrapGAppsHook python3 desktop-file-utils ];

  buildInputs = [ gtk3 glib pantheon.granite libgee sqlGda gtksourceview libxml2 libsecret libssh2 ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Friendly SQL Client";
    longDescription = ''
      Sequeler is a native Linux SQL client built in Vala and Gtk. It allows you
      to connect to your local and remote databases, write SQL in a handy text
      editor with language recognition, and visualize SELECT results in a
      Gtk.Grid Widget.
    '';
    homepage = "https://github.com/Alecaddd/sequeler";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.alecaddd.sequeler";
  };
}
