{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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
    # CVE-2025-10911
    # Source: https://gitlab.gnome.org/GNOME/libxslt/-/merge_requests/77
    # Identical to https://chromium.googlesource.com/chromium/src/+/b124f80df73fe467ac48846536e2542acfc3be20/third_party/libxslt/chromium/0004-Use-a-dedicated-node-type-to-maintain-the-list-of-ca.patch
    ./77-Use-a-dedicated-node-type-to-maintain-the-list-of-cached-rv-ts.patch

    (fetchpatch {
      # listed as CVE-2026-11196 in Chromium, CVE-2026-43703 for ios, no CVE for libxslt
      # https://gitlab.gnome.org/GNOME/libxslt/-/work_items/171
      url = "https://chromium.googlesource.com/chromium/src/+/b124f80df73fe467ac48846536e2542acfc3be20/third_party/libxslt/chromium/0005-Verify-dictionary-ownership-before-aliasing-attribut.patch?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-aXrO+zYhz+71jvD3sWhaWJofnDTxZpgxZNNWAUDlc9o=";
    })
    # https://chromium.googlesource.com/chromium/src/+/b124f80df73fe467ac48846536e2542acfc3be20/third_party/libxslt/chromium/0006-Fix-type-confusion-in-xsltParseTemplateContent.patch
    # the patch as fetched from google fails to apply, probably because of changed tab/space formatting
    # listed as CVE-2026-9947 in Chromium, CVE-2026-43706 for ios, no CVE for libxslt
    ./0006-Fix-type-confusion-in-xsltParseTemplateContent.patch
    (fetchpatch {
      # apparently not known upstream at libxslt
      url = "https://chromium.googlesource.com/chromium/src/+/b124f80df73fe467ac48846536e2542acfc3be20/third_party/libxslt/chromium/0007-Return-an-empty-node-set-from-document-function-with-invalid-uri.patch?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-e5HOJgRCtM0/2LAJ6bgcoDartN+Ax6OVLQrlrtqkiBM=";
    })
    (fetchpatch {
      # https://gitlab.gnome.org/GNOME/libxslt/-/work_items/183
      url = "https://chromium.googlesource.com/chromium/src/+/b124f80df73fe467ac48846536e2542acfc3be20/third_party/libxslt/chromium/0008-Fix-use-after-free-in-direct-pattern-match-cache.patch?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-BxgQSitPAdkv4o9iIJKtlUwwlqDHWJPFMUS7+BPjMoI=";
    })
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
