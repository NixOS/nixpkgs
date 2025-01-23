{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-U23e32Xfa0j+U/CrCZzKjipaA0Yv5szbtTHJWWL52K4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aP/oYt0y7zJ9dyvOo4uWQ44J5qM6LxTo0jN1jIVSpUY=";

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
