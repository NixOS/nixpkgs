{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icann-rdap";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "icann";
    repo = "icann-rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8uvFTjFY7YrohxlD7UwzrQUUoHHEb5mzZoQ64XUQHY=";
  };

  cargoHash = "sha256-2R6GrcuksEOk8GiVkFhMljS12V2n0J1rCw9MCOtwMjA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  # https://github.com/icann/icann-rdap/issues/138
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Official ICANN RDAP tools, containing cli client and server";
    mainProgram = "rdap";
    homepage = "https://github.com/icann/icann-rdap";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ paumr ];
  };
})
