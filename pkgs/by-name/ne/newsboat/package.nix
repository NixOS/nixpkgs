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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsboat";
  version = "2.42";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    tag = "r${finalAttrs.version}";
    hash = "sha256-ZBqYxAX2jPaRycdw7BbhySt2uviICadT/5Z5WZqsqJM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-T6zBr3LoOkPLVkBvfhUdqs7iF2I6fRTZo+uMsrnv+5g=";
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
