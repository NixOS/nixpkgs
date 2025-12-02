{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = "monolith";
    rev = "v${version}";
    hash = "sha256-7D/r9/uY1JcShKgfNUGVTn8P5kUAwUIa/xBbhpReeNw=";
  };

  cargoHash = "sha256-rIwlNXe7me3Ehj1EIYiOYo12FQqovmZT0ui58gFRWWw=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  checkFlags = [ "--skip=tests::cli" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Bundle any web page into a single HTML file";
    mainProgram = "monolith";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.cc0;
    platforms = lib.platforms.unix;
  };
}
