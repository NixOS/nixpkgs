{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "keepass-diff";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CqLH5Dosp26YfqgOVcZilfo5svAEv+pAbi1zebGMnb4=";
  };

  cargoHash = "sha256-QjcXeLLIvegzETIu3xbZQ+o2WYxR6xkALVOOWYWhGUo=";

  meta = {
    description = "CLI-tool to diff Keepass (.kdbx) files";
    homepage = "https://keepass-diff.narigo.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wamserma ];
    mainProgram = "keepass-diff";
  };
}
