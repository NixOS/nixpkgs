{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = version;
    sha256 = "sha256-OFNp+kFDafYbzqb7xfPTO885cAjgWfNeDvUPDKq5GJU=";
  };

  cargoHash = "sha256-0x/x3TRwRinQ/uLCQoRrJOE/mc2snkL/MCz76nQqb5E=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
