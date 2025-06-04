{
  stdenv,
  lib,
  buildPackages,
  gettext,
  meson,
  ninja,
  rustc,
  rustPlatform,
  cargo,
  fetchurl,
  apacheHttpdPackages,
  pkg-config,
  glib,
  libxml2,
  wrapGAppsNoGuiHook,
  itstool,
  gnome,
  _experimental-update-script-combinators,
  common-updater-scripts,
}:

let
  inherit (apacheHttpdPackages) apacheHttpd mod_dnssd;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-user-share";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-share/${lib.versions.major finalAttrs.version}/gnome-user-share-${finalAttrs.version}.tar.xz";
    hash = "sha256-tVgFBwGVwvZYQVuc0shbLNFOqYHWGCOlANTWK4v4OAE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "gnome-user-share-${finalAttrs.version}";
    hash = "sha256-tQoP0yBOCesj2kwgBUoqmcVtFttwML2N+wfSULtfC4w=";
  };

  preConfigure =
    ''
      substituteInPlace data/dav_user_2.4.conf \
        --replace-fail \
          'LoadModule dnssd_module ''${HTTP_MODULES_PATH}/mod_dnssd.so' \
          'LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so' \
        --replace-fail \
          '${"$"}{HTTP_MODULES_PATH}' \
          '${apacheHttpd}/modules'
    ''
    + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      substituteInPlace meson.build --replace-fail \
        "run_command([httpd, '-v']" \
        "run_command(['${stdenv.hostPlatform.emulator buildPackages}', httpd, '-v']"
    '';

  mesonFlags = [
    "-Dhttpd=${apacheHttpd.out}/bin/httpd"
    "-Dmodules_path=${apacheHttpd}/modules"
    "-Dsystemduserunitdir=${placeholder "out"}/etc/systemd/user"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustc
    rustPlatform.cargoSetupHook
    cargo
    gettext
    glib # for glib-compile-schemas
    itstool
    libxml2
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
  ];

  doCheck = true;
  strictDeps = true;

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "gnome-user-share";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version gnome-user-share --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-user-share";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-user-share/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})
