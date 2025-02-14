{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccat";
  version = "003";

  src = fetchFromGitHub {
    owner = "DeeKahy";
    repo = "CopyCat";
    tag = version;
    hash = "sha256-BNXWubJ6eRnuK7+0kE9yHQzjJci5miTSG3dwWE2XDwc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2SI4h5RqzWKWnRmQ2t/eDAOK1ql7jlZKIgPlSiiB6Dg=";

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin) [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  meta = {
    description = "Utility to copy project tree contents to clipboard";
    homepage = "https://github.com/DeeKahy/CopyCat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.deekahy ];
    mainProgram = "ccat";
  };
}
