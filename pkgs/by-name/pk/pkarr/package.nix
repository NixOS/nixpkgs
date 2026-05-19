{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkarr";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R8wUUWBPgXdQM9CwZS1lxyEC0YQaS5HU6dwKiCmQOaM=";
  };

  cargoHash = "sha256-pUO+wIWLdSZSRGi/pAVE6+CB5gMG5jBvVXJ7g8WMb40=";

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
})
