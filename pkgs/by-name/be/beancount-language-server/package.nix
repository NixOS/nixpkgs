{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-cx/Y0jBpnNN+QVEovpbhCG70VwOqwDE+8lBcRAJtlF4=";
  };

  cargoHash = "sha256-P3Oug9YNsTmsOz68rGUcYJwq9NsKErHt/fOCvqXixNU=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for beancount files";
    mainProgram = "beancount-language-server";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
