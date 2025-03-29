{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccat";
  version = "004";

  src = fetchFromGitHub {
    owner = "DeeKahy";
    repo = "CopyCat";
    tag = version;
    hash = "sha256-HLT88ghyT9AwvBTf7NrFkSPqMAh90GrBqZVXN5aaG3w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gjFVvP2h+HJdDdNVtqTT1E1s4ZYXfWuhtMBRJkWRcDw=";

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
