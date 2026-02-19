{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "beancount-language-server";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    tag = finalAttrs.version;
    hash = "sha256-TLpYnq+EiWg+X8pviErMkTU8R6gxwqasTSnA76PcF6U=";
  };

  cargoHash = "sha256-xxFHIJT935NLF9xl9AF1ipiaLhs4WGW1pqtLPDK4Wnk=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = {
    description = "Language Server Protocol (LSP) for beancount files";
    mainProgram = "beancount-language-server";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ polarmutex ];
  };
})
