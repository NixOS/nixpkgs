{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  cargo,
  rustc,
  stfl,
  sqlite,
  curl,
  gettext,
  pkg-config,
  libxml2,
  json_c,
  ncurses,
  asciidoctor,
  libiconv,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsboat";
  version = "2.41";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    tag = "r${finalAttrs.version}";
    hash = "sha256-LhEhbK66OYwAD/pel81N7Hgh/xEvnFR8GlZzgqZIe5M=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-CyhyzNw2LXwIVf/SX2rQRvEex5LmjZfZKgCe88jthz0=";
  };

  # fix macOS build
  patches = [
    (fetchpatch {
      url = "https://github.com/newsboat/newsboat/commit/4139a0ba1ec87e442ef1408823b07fc739742f9d.patch";
      hash = "sha256-zdtdpUQGATq/9w+hAY/Va9Ob95c8VT2D9aKFmAF+O0c=";
    })
    (fetchpatch {
      url = "https://github.com/newsboat/newsboat/commit/4eb748b6b6b63acddb3582e012442e519e8704ea.patch";
      hash = "sha256-A/0WbuMIapTsLoziUPr95ZctIr2hW7JOJSdMVaWayYI=";
    })
  ];

  # allow other ncurses versions on Darwin
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace config.sh --replace-fail "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    gettext
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
    ncurses
  ];

  buildInputs = [
    stfl
    sqlite
    curl
    libxml2
    json_c
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    gettext
  ];

  # https://github.com/NixOS/nixpkgs/pull/98471#issuecomment-703100014 . We set
  # these for all platforms, since upstream's gettext crate behavior might
  # change in the future.
  GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
  GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://newsboat.org/";
    changelog = "https://github.com/newsboat/newsboat/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with lib.maintainers; [
      dotlambda
      nicknovitski
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "newsboat";
  };
})
