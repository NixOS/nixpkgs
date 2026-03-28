{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsboat";
  version = "2.43";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    tag = "r${finalAttrs.version}";
    hash = "sha256-XnA20uylHoly1P5qpM2JmkkV6C5//Xu5M+CjWwCiI7c=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/newsboat/newsboat/commit/f7936d13013d33946b28b2ac51f1266423d66b23.patch";
      hash = "sha256-MnL/ylTIJJV1+3I1OxzNWedLUEZ4viuzxXNM63qk1aM=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+QyN0YDQmSGVZ2ckLd5SDYRw/wZYFY6GNteeTRrNDcU=";
  };

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

  env = {
    # https://github.com/NixOS/nixpkgs/pull/98471#issuecomment-703100014 . We set
    # these for all platforms, since upstream's gettext crate behavior might
    # change in the future.
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";
  };

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
