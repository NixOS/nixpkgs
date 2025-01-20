{
  stdenv,
  lib,
  fetchurl,
  fetchpatch2,
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
  withTpm2Tss ? lib.meta.availableOn stdenv.hostPlatform tpm2-tss && stdenv.hostPlatform.isx86_64,
  abrmdSupport ? withTpm2Tss,
  tpm2-tss,
  swtpm,
  tpm2-abrmd,
}:

assert abrmdSupport -> withTpm2Tss;

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.21.4";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-Fj0I14O+bUq5qXnOtaT+y8HZZg08NBaMWBMBzVORKyA=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/libsecret/-/merge_requests/141
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/libsecret/-/commit/208989323211c756dff690115e5cbde5ef7491ce.patch";
      hash = "sha256-DtRbqyyoMttEYf6B16m9O72Yjurv6rpbnqH7AlrAU4k=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
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

  buildInputs =
    [
      libgcrypt
    ]
    ++ lib.optionals withTpm2Tss [ tpm2-tss ]
    ++ lib.optionals abrmdSupport [ tpm2-abrmd ];

  propagatedBuildInputs = [
    glib
  ];

  nativeCheckInputs =
    [
      python3
      python3Packages.dbus-python
      python3Packages.pygobject3
      dbus
      gjs
    ]
    ++ lib.optionals withTpm2Tss [
      swtpm
      tpm2-abrmd
    ];

  mesonFlags = [
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonBool "tpm2" withTpm2Tss)
  ];

  doCheck = stdenv.hostPlatform.isLinux && withIntrospection;
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs ./tool/test-*.sh
  '';

  preConfigure = lib.optionalString abrmdSupport ''
    # Add dependencies on TCTI modules required for user‐space TPM resource
    # manager support so that they can be loaded at run‐time.
    mesonFlagsArray+=("-Dc_link_args=-Wl,--push-state,--no-as-needed -ltss2-tcti-tabrmd -ltss2-tcti-device -Wl,--pop-state")
  '';

  preCheck =
    ''
      # Our gobject-introspection patches make the shared library paths absolute
      # in the GIR files. When running tests, the library is not yet installed,
      # though, so we need to replace the absolute path with a local one during build.
      # We are using a symlink that will be overwitten during installation.
      mkdir -p $out/lib $out/lib
      ln -s "$PWD/libsecret/libmock-service.so" "$out/lib/libmock-service.so"
      ln -s "$PWD/libsecret/libsecret-1.so.0" "$out/lib/libsecret-1.so.0"
    ''
    + lib.optionalString withTpm2Tss ''
      export XDG_CONFIG_HOME="$(mktemp -d)"

      export swtpm="$(mktemp -d)"
      mkdir "$swtpm/state"

      swtpm_setup --create-config-files --root
      swtpm_setup \
        --tpm-state "$swtpm/state" \
        --tpm2 \
        --createek \
        --allow-signing \
        --decryption \
        --create-ek-cert \
        --create-platform-cert \
        --lock-nvram
    '';

  checkPhase =
    let
      checkScript =
        lib.optionalString withTpm2Tss ''
          swtpm socket \
            --server "type=unixio,path=$swtpm/sock" \
            --daemon \
            --ctrl "type=unixio,path=$swtpm/sock.ctrl" \
            --tpmstate "dir=$swtpm/state" \
            --tpm2 \
            --flags startup-clear

          trap "swtpm_ioctl --unix '$swtpm/sock.ctrl' -s" EXIT

          tpm2-abrmd \
            --tcti="swtpm:path=$swtpm/sock" \
            --allow-root \
            --flush-all \
            --session &

          export TCTI="tabrmd:bus_type=session"
        ''
        + lib.optionalString (!abrmdSupport) ''
          # Ensure that user‐space resource manager TCTI module can be loaded
          # for testing.
          export LD_LIBRARY_PATH+=":${lib.makeLibraryPath [ tpm2-abrmd ]}"
        ''
        + ''
          meson test --print-errorlogs --timeout-multiplier 0
        '';
    in
    ''
      runHook preCheck

      dbus-run-session \
        --config-file=${dbus}/share/dbus-1/session.conf \
        sh -c ${lib.escapeShellArg checkScript}

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
      packageName = pname;
      # Does not seem to use the odd-unstable policy: https://gitlab.gnome.org/GNOME/libsecret/issues/30
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Library for storing and retrieving passwords and other secrets";
    homepage = "https://gitlab.gnome.org/GNOME/libsecret";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "secret-tool";
    inherit (glib.meta) platforms maintainers;
  };
}
