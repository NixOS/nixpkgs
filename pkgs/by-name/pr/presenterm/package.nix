{ lib
, fetchFromGitHub
, rustPlatform
, libsixel
, stdenv
, nix-update-script
, testers
, presenterm
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "refs/tags/v${version}";
    hash = "sha256-sMhowTXPzZcIOV4Ny9NzvgXGsZSPBJGDg9JvuoZoSUc=";
  };

  buildInputs = [
    libsixel
  ];

  cargoHash = "sha256-2aHJnGSuP0TEBMxF1zljbEyk1g6ECTpnByyH8jaj78s=";

  # Crashes at runtime on darwin with:
  # Library not loaded: .../out/lib/libsixel.1.dylib
  buildFeatures = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "sixel" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = presenterm;
      command = "presenterm --version";
    };
  };

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
