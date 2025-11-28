{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = version;
    sha256 = "sha256-FPbZH8cEYQ9wbSm6jA5/uiX8Wgx/FyuIJ/gPgSKUhBA=";
  };

  cargoHash = "sha256-haHJkyYAc4+ODJNEWiXzbl1xbJ7pyrtnPX/+ubjvX44=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
