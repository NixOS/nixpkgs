{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-aqWenvNAdDL7B7J1hvt+JXT73SJJKu9KFlpUReOp3s4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h2y8h3rZABspyWXEWy4/me4NhlXzghC7KH1SyfDzGfI=";

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
