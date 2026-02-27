{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "amber";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-vmgUWPxfJhzKmDq5aP/ZpyY5c/y7+ZzEEcjaTl6aUUo=";
  };

  cargoHash = "sha256-ejBu7ijActk7Je8zr10Ei1ULv9ZP00gNdZO3zdK2AM4=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.bdesham ];
  };
})
