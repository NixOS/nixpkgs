{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-0tMGTKcuvyDE5281nGCvZKYJKIEAU01G6vV8Fnt/1ZQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Xqwytw6dRL/bZutnZxQchSfWCzjACw2/UAr4YW5fz44=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage = "https://github.com/nix-community/nixdoc";
    license = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      hsjobeki
    ];
    platforms = platforms.unix;
  };
}
