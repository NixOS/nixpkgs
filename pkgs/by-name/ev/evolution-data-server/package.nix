{ stdenv
, lib
, fetchurl
, pkg-config
, gnome
, _experimental-update-script-combinators
, python3
, gobject-introspection
, gettext
, libsoup_3
, libxml2
, libsecret
, icu
, sqlite
, libcanberra-gtk3
, p11-kit
, db
, nspr
, nss
, libical
, gperf
, wrapGAppsHook3
, glib-networking
, gsettings-desktop-schemas
, pcre
, vala
, cmake
, ninja
, libkrb5
, openldap
, enableOAuth2 ? stdenv.hostPlatform.isLinux
, webkitgtk_4_1
, webkitgtk_6_0
, json-glib
, glib
, gtk3
, gtk4
, withGtk3 ? true
, withGtk4 ? false
, libphonenumber
, libuuid
, gnome-online-accounts
, libgweather
, boost
, protobuf
, libiconv
, makeHardcodeGsettingsPatch
}:

stdenv.mkDerivation rec {
  pname = "evolution-data-server";
  version = "3.53.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${lib.versions.majorMinor version}/evolution-data-server-${version}.tar.xz";
    hash = "sha256-QRhmMD/rQoac1mHXr+ygF/hh/ABHy4Dgmt8QXsqiIbU=";
  };

  patches = [
    # Avoid using wrapper function, which the hardcode gsettings
    # patch generator cannot handle.
    ./drop-tentative-settings-constructor.patch
  ];

  prePatch = ''
    substitute ${./hardcode-gsettings.patch} hardcode-gsettings.patch \
      --subst-var-by EDS ${glib.makeSchemaPath "$out" "evolution-data-server-${version}"} \
      --subst-var-by GDS ${glib.getSchemaPath gsettings-desktop-schemas}
    patches="$patches $PWD/hardcode-gsettings.patch"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gettext
    python3
    gperf
    wrapGAppsHook3
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libsecret
    libsoup_3
    gnome-online-accounts
    p11-kit
    libgweather
    icu
    sqlite
    libkrb5
    openldap
    glib-networking
    libcanberra-gtk3
    pcre
    libphonenumber
    libuuid
    boost
    protobuf
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ] ++ lib.optionals withGtk3 [
    gtk3
  ] ++ lib.optionals (withGtk3 && enableOAuth2) [
    webkitgtk_4_1
  ] ++ lib.optionals withGtk4 [
    gtk4
  ] ++ lib.optionals (withGtk4 && enableOAuth2) [
    webkitgtk_6_0
  ];

  propagatedBuildInputs = [
    db
    nss
    nspr
    libical
    libsoup_3
    libxml2
    json-glib
  ];

  cmakeFlags = [
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "-DWITH_PHONENUMBER=ON"
    "-DENABLE_GTK=${lib.boolToString withGtk3}"
    "-DENABLE_EXAMPLES=${lib.boolToString withGtk3}"
    "-DENABLE_CANBERRA=${lib.boolToString withGtk3}"
    "-DENABLE_GTK4=${lib.boolToString withGtk4}"
    "-DENABLE_OAUTH2_WEBKITGTK=${lib.boolToString (withGtk3 && enableOAuth2)}"
    "-DENABLE_OAUTH2_WEBKITGTK4=${lib.boolToString (withGtk4 && enableOAuth2)}"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/modules/SetupBuildFlags.cmake \
      --replace "-Wl,--no-undefined" ""
    substituteInPlace src/services/evolution-alarm-notify/e-alarm-notify.c \
      --replace "G_OS_WIN32" "__APPLE__"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/lib/evolution-data-server/*.dylib $out/lib/
  '';

  passthru = {
    hardcodeGsettingsPatch = makeHardcodeGsettingsPatch {
      schemaIdToVariableMapping = {
        "org.gnome.Evolution.DefaultSources" = "EDS";
        "org.gnome.evolution.shell.network-config" = "EDS";
        "org.gnome.evolution-data-server.addressbook" = "EDS";
        "org.gnome.evolution-data-server.calendar" = "EDS";
        "org.gnome.evolution-data-server" = "EDS";
        "org.gnome.desktop.interface" = "GDS";
      };
      inherit src patches;
    };
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "evolution-data-server";
          versionPolicy = "odd-unstable";
        };
        updatePatch = _experimental-update-script-combinators.copyAttrOutputToFile "evolution-data-server.hardcodeGsettingsPatch" ./hardcode-gsettings.patch;
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updatePatch
      ];
  };

  meta = with lib; {
    description = "Unified backend for programs that work with contacts, tasks, and calendar information";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-data-server";
    changelog = "https://gitlab.gnome.org/GNOME/evolution-data-server/-/blob/${version}/NEWS?ref_type=tags";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
