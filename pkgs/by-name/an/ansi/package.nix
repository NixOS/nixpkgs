{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ansi-escape-sequences-cli";
  version = "0.2.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-/dyvhgNUPitSUGtQSEMPGqHED1YNGSKumIY6Rj0hnH0=";
  };

  cargoHash = "sha256-vAJmpILjzj9pqW2M9gIkQiKAntwvhwsHLCSbvHJ4Fug=";

  meta = {
    description = "Quickly get ANSI escape sequences";
    longDescription = ''
      CLI utility called "ansi" to quickly get ANSI escape sequences. Supports
      the colors and styles, such as bold or italic.
    '';
    homepage = "https://github.com/phip1611/ansi-escape-sequences-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phip1611 ];
    mainProgram = "ansi";
  };
})
