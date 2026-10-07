{
  stdenv,
  lib,
  cmake,
  ncurses,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csol";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nielssp";
    repo = "csol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EWQL63xE6Z7npXH5ht5KYtQaPrDwuPe2ZhmHrvYIAu8=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  patches = [ ./replace-etc-path.patch ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ ncurses ];

  postFixup = ''
    wrapProgram $out/bin/csol \
      --add-flags "-c $out/etc/xdg/csol/csolrc"
  '';

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "A small collection of solitaire/patience games (Klondike, FreeCell, Spider, Yukon, etc.) to play in the terminal";
    license = lib.licenses.mit;
    homepage = "https://nielssp.dk/csol";
    changelog = "https://github.com/nielssp/csol/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ gimura ];
    mainProgram = "csol";
  };
})
