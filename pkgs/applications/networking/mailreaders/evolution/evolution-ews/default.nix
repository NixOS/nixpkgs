{ stdenv
, lib
, fetchurl
, gnome
, cmake
, gettext
, intltool
, pkg-config
, evolution-data-server
, evolution
, gtk3
, libsoup_3
, libical
, json-glib
, libmspack
, webkitgtk_4_1
, runCommand
, coccinelle
, git
, substituteAll
, glib
}:

stdenv.mkDerivation rec {
  pname = "evolution-ews";
  version = "3.45.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "trqNVI3KpCqYMOnqGNX6lNs1ZBPxZQv9btNnYKGG4o8=";
  };

  patches = [
    # evolution-ews contains .so files loaded by evolution-data-server refering
    # schemas from evolution. evolution-data-server is not wrapped with
    # evolution's schemas because it would be a circular dependency with
    # evolution.
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      evo = glib.makeSchemaPath evolution evolution.name;
    })
  ];

  nativeBuildInputs = [
    cmake
    gettext
    intltool
    pkg-config
  ];

  buildInputs = [
    evolution-data-server
    evolution
    gtk3
    libsoup_3
    libical
    json-glib
    libmspack
    # For evolution-shell-3.0
    webkitgtk_4_1
  ];

  cmakeFlags = [
    # don't try to install into ${evolution}
    "-DFORCE_INSTALL_PREFIX=ON"
  ];

  passthru = {
    hardcodeGsettingsPatch =
      runCommand
        "hardcode-gsettings.patch"
        {
          inherit src;
          nativeBuildInputs = [
            git
            coccinelle
          ];
        }
        ''
          unpackPhase
          cd "''${sourceRoot:-.}"
          git init
          git add -A
          spatch --sp-file "${./hardcode-gsettings.cocci}" --dir . --in-place
          git diff > "$out"
        '';

    updateScript =
      let
        gnomeUpdate = gnome.updateScript {
          packageName = "evolution-ews";
          versionPolicy = "odd-unstable";
        };

        newUpdateScript = lib.escapeShellArgs gnomeUpdate.command + " && cp --no-preserve=mode \"$(nix-build -A evolution-ews.hardcodeGsettingsPatch)\" \"$0\"";
      in
      gnomeUpdate // {
        command = [ "sh" "-c" newUpdateScript ./hardcode-gsettings.patch ];
      };
  };

  meta = with lib; {
    description = "Evolution connector for Microsoft Exchange Server protocols";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-ews";
    license = licenses.lgpl21Plus; # https://gitlab.gnome.org/GNOME/evolution-ews/issues/111
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
