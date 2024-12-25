{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  stfl,
  sqlite,
  curl,
  gettext,
  pkg-config,
  libxml2,
  json_c,
  ncurses,
  darwin,
  asciidoctor,
  libiconv,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.38";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    hash = "sha256-RekP88qZ4VaH5JG190BbVrBHnoUr+UVWvFmdPeyY8Yw=";
  };

  cargoHash = "sha256-mripE0oeMLn9svhKH/dcH7VKYHGyZKfrDcoBdL+QcDQ=";

  # TODO: Check if that's still needed
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs =
    [
      pkg-config
      asciidoctor
      gettext
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeWrapper
      ncurses
    ];

  buildInputs =
    [
      stfl
      sqlite
      curl
      libxml2
      json_c
      ncurses
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        Foundation
        libiconv
        gettext
      ]
    );

  postBuild = ''
    make -j $NIX_BUILD_CORES prefix="$out"
  '';

  # https://github.com/NixOS/nixpkgs/pull/98471#issuecomment-703100014 . We set
  # these for all platforms, since upstream's gettext crate behavior might
  # change in the future.
  GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
  GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";

  doCheck = true;

  preCheck = ''
    make -j $NIX_BUILD_CORES test
  '';

  postInstall =
    ''
      make -j $NIX_BUILD_CORES prefix="$out" install
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      for prog in $out/bin/*; do
        wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
      done
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 newsboat $out/bin/newsboat
    install -Dm755 podboat $out/bin/podboat
    runHook postInstall
  '';

  meta = {
    homepage = "https://newsboat.org/";
    changelog = "https://github.com/newsboat/newsboat/blob/${src.rev}/CHANGELOG.md";
    description = "Fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with lib.maintainers; [
      dotlambda
      nicknovitski
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "newsboat";
  };
}
