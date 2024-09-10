{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "see";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4BVnM3SYDHsfjMsrzdFNuQ2jF5nQKa1+QH4Jf4HsXvg=";
  };

  cargoHash = "sha256-kQkrn7s5UuNSHkAM+hk8mFWDpnHtt8UcyyXGr1m4xkg=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Cute cat(1) for the terminal with advanced code viewing, Markdown rendering, 🌳 tree-sitter syntax highlighting, and more.";
    longDescription = "see is a powerful file visualization tool for the terminal, offering advanced code viewing capabilities, Markdown rendering, and more. It provides syntax highlighting, emoji support, and image rendering capabilities, offering a visually appealing way to view various file types directly in your console.";
    homepage = "https://github.com/guilhermeprokisch/see";
    license = lib.licenses.mit;
    mainProgram = "see";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
