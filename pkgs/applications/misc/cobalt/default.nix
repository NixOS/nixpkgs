{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.8";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-neOJ3UqRisCcyarRIXfHyl9nAe2Wl9IXVDNwIYEQYys=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j2xmEoMV7lVhqj4lKWA3QdEDEGUpRlZc4ikZoDQJlB8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
    mainProgram = "cobalt";
  };
}
