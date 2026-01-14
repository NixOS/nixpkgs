{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = version;
    sha256 = "sha256-gzwsPRhsAQTraiK/N5dKEj8NTpV/mYmECpS4KVl4Ql8=";
  };

  cargoHash = "sha256-+YvEptJlNjomIsyS7cNImwYa1SxawY05e5vq9VmrktA=";

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
