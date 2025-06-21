{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  perl,
  writableTmpDirAsHomeHook,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-2R6GrcuksEOk8GiVkFhMljS12V2n0J1rCw9MCOtwMjA=";

  nativeBuildInputs = [ perl ];

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
