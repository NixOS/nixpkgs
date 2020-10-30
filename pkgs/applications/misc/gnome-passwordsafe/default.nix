{ stdenv
, meson
, ninja
, pkg-config
, gettext
, fetchFromGitLab
, python3
, libhandy
, libpwquality
, wrapGAppsHook
, gtk3
, glib
, gdk-pixbuf
, gobject-introspection
, desktop-file-utils
, appstream-glib }:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-passwordsafe";
  version = "3.99.2";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "PasswordSafe";
    rev = version;
    sha256 = "0pi2l4gwf8paxm858mxrcsk5nr0c0zw5ycax40mghndb6b1qmmhf";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    gdk-pixbuf
    libhandy
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    construct

    # pykeepass 3.2.1 changed some exception types, and is not backwards compatible.
    # Remove override once the MR is merged upstream.
    # https://gitlab.gnome.org/World/PasswordSafe/-/merge_requests/79
    (pykeepass.overridePythonAttrs (old: rec {
      version = "3.2.0";
      src = fetchPypi {
        pname = "pykeepass";
        inherit version;
        sha256 = "1ysjn92bixq8wkwhlbhrjj9z0h80qnlnj7ks5478ndkzdw5gxvm1";
      };
      propagatedBuildInputs = old.propagatedBuildInputs ++ [ pycryptodome ];
    }))

  ] ++ [
    libpwquality # using the python bindings
  ];

  meta = with stdenv.lib; {
    broken = stdenv.hostPlatform.isStatic; # libpwquality doesn't provide bindings when static
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/PasswordSafe";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}

