{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frezze";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "AbelHristodor";
    repo = "frezze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zjZOqw7LEgdN4knjDDDFghi81ZJhgFn06OZrUSrKtSg=";
  };

  cargoHash = "sha256-9oC14u/WTHUw3VGXsdZQDYN3jAR0Y+zig0ZRci+dl70=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Block developers from merging anything on Github";
    homepage = "https://github.com/AbelHristodor/frezze";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "frezze";
  };
})
