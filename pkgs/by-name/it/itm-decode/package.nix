{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "itm-decode";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rtic-scope";
    repo = "itm";
    rev = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  meta = {
    description = "A tool to parse and dump ARM [ITM] packets";
    homepage = "https://github.com/rtic-scope/itm";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ ];
  };
})
