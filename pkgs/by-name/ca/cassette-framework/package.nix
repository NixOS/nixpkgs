{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  fontconfig,
  libxkbcommon,
  libxcb,
  xcbutilwm,
  xcbutilkeysyms,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cassette-framework";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fraawlen";
    repo = "cassette";
    tag = finalAttrs.version;
    hash = "sha256-+SC/K2vHVXcGesc2AbJS+9rTxEZOoOwBnQZeLUITsjc=";
  };

  strictDeps = true;

  buildInputs = [
    libxkbcommon
    cairo
    fontconfig
    libxcb
    xcbutilwm
    xcbutilkeysyms
  ];

  NIX_LDFLAGS = lib.optionals stdenv.isDarwin [
    "-rpath"
    "@loader_path/../lib"
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = ''
    nix-update
  '';

  meta = {
    homepage = "https://github.com/fraawlen/cassette";
    description = "POSIX application framework with a cassette-futurism aesthetic UI";
    changelog = "https://github.com/fraawlen/cassette/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fccapria ];
  };
})
