{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iDJvPgBmlca0hJnLrQcGJwlBeX8U1AX4D56gz13ieGg=";
  };

  checkType = "debug";

  cargoHash = "sha256-wlIDqT+uoWgDaBOdrHwJU2AEwUXOJPQRF5RsCq/26m0=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time.";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim maltejanz ];
  };
}
