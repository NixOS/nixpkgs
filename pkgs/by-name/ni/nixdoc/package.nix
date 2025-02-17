{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-7UOjmW8Ef4mEvj7SINaKWh2ZuyNMVEXB82mtuZTQiPA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Aw794yhIET8/pnlQiK2xKVbYC/Kd5MExvFTwkv4LLTc=";

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
