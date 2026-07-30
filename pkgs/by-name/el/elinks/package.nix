{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  bzip2,
  zlib,
  brotli,
  zstd,
  xz,
  openssl,
  meson,
  ninja,
  gettext,
  python3,
  pkg-config,
  xmlto,
  docbook_xml_dtd_42,
  gpm,
  libidn2,
  tre,
  expat,
  lua,
  curl,
  libcss,
  libdom,
  nix-update-script,
  # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile ? false,
  guile ? null,
  enablePython ? false,
  python ? null,
  enablePerl ? (!stdenv.hostPlatform.isDarwin) && (stdenv.hostPlatform == stdenv.buildPlatform),
  perl ? null,
  # re-add javascript support when upstream supports modern spidermonkey
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "elinks";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "elinks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aQ+q2I6uTVv5kpKBaGJ1xiE/9vv9T7JI05VX/ROkAqA=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  buildInputs = [
    ncurses
    bzip2
    zlib
    brotli
    zstd
    xz
    openssl
    libidn2
    tre
    expat
    lua
    curl
    libcss
    libdom
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext
  ++ lib.optional enableGuile guile
  ++ lib.optional enablePython python
  ++ lib.optional enablePerl perl;

  nativeBuildInputs = [
    meson
    ninja
    gettext
    perl
    python3
    pkg-config
    xmlto
  ];

  env =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      C_INCLUDE_PATH = "${lib.getInclude gpm}/include";
      LIBRARY_PATH = "${lib.getLib gpm}/lib";
    }
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      LDFLAGS = "-liconv";
    };

  strictDeps = true;
  __structuredAttrs = true;

  mesonFlags =
    (map (f: lib.mesonBool f true) [
      "finger"
      "html-highlight"
      "gopher"
      "gemini"
      "cgi"
      "nntp"
      "256-colors"
      "true-color"
      "brotli"
      "lzma"
      "terminfo"
      "reproducible"
    ])
    ++ [
      (lib.mesonOption "luapkg" "lua")
      (lib.mesonBool "gpm" stdenv.hostPlatform.isLinux)
      (lib.mesonBool "guile" enableGuile)
      (lib.mesonBool "python" enablePython)
      (lib.mesonBool "perl" enablePerl)
    ];

  postPatch = ''
    patchShebangs doc/tools
    substituteInPlace doc/tools/asciidoc/docbook.conf \
      --replace-fail "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" "${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd"
  '';

  preConfigure = ''
    mesonFlags+=("-Dsource-date-epoch=$SOURCE_DATE_EPOCH")
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Full-featured text-mode web browser";
    mainProgram = "elinks";
    homepage = "https://github.com/rkd77/elinks";
    license = lib.licenses.gpl2Only;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      iblech
    ];
  };
})
