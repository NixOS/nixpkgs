{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nkyi6X9W92yLaSPCg3zk0z/Pwue6dGK09iCDmWliFeg=";
  };

  checkType = "debug";

  cargoHash = "sha256-CZOdxrQ/50xznc8cfvi+6QFmMpPOS1st+yVPtAkZ3/A=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [
      shyim
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
}
