{
  stdenv,
  lib,
  fetchurl,
  glib,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxslt,
  python3,
  python3Packages,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  libgcrypt,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  vala,
  gi-docgen,
  gnome,
  gjs,
  libintl,
  dbus,
  withTpm2Tss ? false,
  abrmdSupport ? false,
  writeShellApplication,
  tpm2-tss,
  tpm2-abrmd,
  libsecret,
}:

assert abrmdSupport -> withTpm2Tss;

let
  tpm-emu = writeShellApplication {
    name = "tpm-emu";
    runtimeInputs = [
      dbus
      tpm2-abrmd
    ];

    text = ''
      coproc {
        # Monitor session bus for name acquisition
        dbus-monitor "type='signal',interface='org.freedesktop.DBus',member='NameAcquired',arg0='com.intel.tss2.Tabrmd'"
      }

      # Discard initial dbus-monitor output
      while read -r -t 0.1 -u "''${COPROC[0]}"; do :; done

      tpm2-abrmd \
        --tcti=libtpms \
        --allow-root \
        --flush-all \
        --session &

      # Terminate tpm2-abrmd on exit
      # shellcheck disable=SC2064 # immediate expansion intended
      trap "kill '$!'" EXIT

      # Wait for daemon to become available to avoid spurious test failures
      read -r -t 60 -u "''${COPROC[0]}"
      kill "$COPROC_PID"

      TCTI="tabrmd:bus_type=session" "$@"
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.21.7";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/libsecret/${lib.versions.majorMinor version}/libsecret-${version}.tar.xz";
    hash = "sha256-a0UuR1BZCitWF63EACbyjS9JA94V8SUOHRxAv9aO1V4=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxslt # for xsltproc for building man pages
    docbook-xsl-nons
    docbook_xml_dtd_42
    libintl
    vala
    glib
  ]
  ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    libgcrypt
  ]
  ++ lib.optionals withTpm2Tss [ tpm2-tss ]
  ++ lib.optionals abrmdSupport [ tpm2-abrmd ];

  propagatedBuildInputs = [
    glib
  ];

  nativeCheckInputs = [
    python3
    python3Packages.dbus-python
    python3Packages.pygobject3
    dbus
    gjs
  ];

  mesonFlags = [
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonBool "tpm2" withTpm2Tss)
    (lib.mesonOption "bashcompdir" "share/bash-completion/completions")
  ];

  doCheck = stdenv.hostPlatform.isLinux && withIntrospection;
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs ./tool/test-*.sh

    # dbus-run-session defaults to FHS path
    substituteInPlace meson.build --replace-fail \
      "exe_wrapper: dbus_run_session," \
      "exe_wrapper: [dbus_run_session, '--config-file=${dbus}/share/dbus-1/session.conf'${lib.optionalString withTpm2Tss ", '${lib.getExe tpm-emu}'"}],"
  '';

  preConfigure = lib.optionalString abrmdSupport ''
    # Add dependencies on TCTI modules required for user‐space TPM resource
    # manager support so that they can be loaded at run time through dlopen().
    mesonFlagsArray+=("-Dc_link_args=-Wl,--push-state,--no-as-needed -ltss2-tcti-tabrmd -ltss2-tcti-device -Wl,--pop-state")
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overwitten during installation.
    mkdir -p $out/lib $out/lib
    ln -s "$PWD/libsecret/libmock-service.so" "$out/lib/libmock-service.so"
    ln -s "$PWD/libsecret/libsecret-1.so.0" "$out/lib/libsecret-1.so.0"
  ''
  + lib.optionalString (withTpm2Tss && !abrmdSupport) ''
    # If abrmdSupport is disabled, the user‐space resource manager TCTI
    # module is not linked at compile time. It is however needed during
    # testing because the TPM emulator lacks an integrated resource manager
    # The module path is therefore injected temporarly using the
    # LD_LIBRARY_PATH environment variable, so that it may be found by
    # dlopen().
    #
    # If abrmdSupport is enabled, this is avoided to check that the
    # module has been properly linked and can be located through the
    # DT_RUNPATH and DT_NEEDED entries in libsecret-1.so.
    export LD_LIBRARY_PATH+=":${lib.makeLibraryPath [ tpm2-abrmd ]}"
  '';

  checkPhase = ''
    runHook preCheck

    meson test --print-errorlogs --timeout-multiplier 0

    runHook postCheck
  '';

  postCheck = ''
    # This is test-only so it won’t be overwritten during installation.
    rm "$out/lib/libmock-service.so"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libsecret";
      # Does not seem to use the odd-unstable policy: https://gitlab.gnome.org/GNOME/libsecret/issues/30
      versionPolicy = "none";
    };

    tests = {
      libsecret-tpm2 = libsecret.override {
        withTpm2Tss = true;
        abrmdSupport = false;
      };

      libsecret-tpm2-abrmd = libsecret.override {
        withTpm2Tss = true;
        abrmdSupport = true;
      };
    };
  };

  meta = {
    description = "Library for storing and retrieving passwords and other secrets";
    homepage = "https://gitlab.gnome.org/GNOME/libsecret";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "secret-tool";
    platforms =
      if withTpm2Tss then
        lib.intersectLists glib.meta.platforms tpm2-tss.meta.platforms
      else
        glib.meta.platforms;
    inherit (glib.meta) maintainers teams;
  };
}
