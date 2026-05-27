{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "haylxon";
  version = "1.1.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "hxn";
    hash = "sha256-pNOMCltMIKLJ8dNDzVa7MShpAROzvqK65d37fj+VXLQ=";
  };

  cargoHash = "sha256-3muxqWOYCNXcV6WEcUwtmn2fKudU0vJtNegr8Nf6x50=";

  meta = {
    description = "Save screenshots of urls and webpages from terminal";
    homepage = "https://github.com/pwnwriter/haylxon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scientiac ];
    mainProgram = "hxn";
  };
})
