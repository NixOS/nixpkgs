{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  libxml2,
  findXMLCatalogs,
  gettext,
  python3,
  ncurses,
  libgcrypt,
  cryptoSupport ? false,
  pythonSupport ? libxml2.pythonSupport,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxslt";
  version = "1.1.45";

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
    "devdoc"
  ]
  ++ lib.optional pythonSupport "py";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxslt/${lib.versions.majorMinor finalAttrs.version}/libxslt-${finalAttrs.version}.tar.xz";
    hash = "sha256-ms/mhBnE0GpFxVAyGzISdi2S9BRlBiyk6hnmMu5dIW4=";
  };

  patches = [
    # Fix use-after-free with key data stored cross-RVT
    # https://gitlab.gnome.org/GNOME/libxslt/-/issues/144
    # Source: https://gitlab.gnome.org/GNOME/libxslt/-/merge_requests/77
    ./77-Use-a-dedicated-node-type-to-maintain-the-list-of-cached-rv-ts.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libxml2.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gettext
  ]
  ++ lib.optionals pythonSupport [
    libxml2.py
    python3
    ncurses
  ]
  ++ lib.optionals cryptoSupport [
    libgcrypt
  ];

  propagatedBuildInputs = [
    findXMLCatalogs
  ];

  configureFlags = [
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python3.pythonOnBuildForHost.interpreter}")
    (lib.withFeature cryptoSupport "crypto")
  ];

  enableParallelBuilding = true;

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
  ''
  + lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput ${python3.sitePackages} "$py"
  '';

  passthru = {
    inherit pythonSupport;

    updateScript = gnome.updateScript {
      packageName = "libxslt";
      versionPolicy = "none";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/libxslt";
    description = "C library and tools to do XSL transformations";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jtojnar ];
    broken = pythonSupport && !libxml2.pythonSupport; # see #73102 for why this is not an assert
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "xmlsoft" finalAttrs.version;
  };
})
