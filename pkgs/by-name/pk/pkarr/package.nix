{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkarr";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sh7ly4jmW7XTizsxGV/iDsWjbhxEEall+dUNkEtYahc=";
  };

  cargoHash = "sha256-ikLXNXnU3ysZrB6pcZcusOziBlYM9fCaFvWM6CKe9Zg=";

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
})
