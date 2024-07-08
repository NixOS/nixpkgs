{ lib, pkgs, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bald";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "NotBalds";
    repo = "bald";
    rev = "v${version}";
    hash = "sha256-uOuJdtLiijjQDlrI3Ps9Bg7gL8mkDQzDZTiJJeOXE2A=";
  };

  nativeBuildInputs = with pkgs; [ gnumake gcc ];

  buildPhase = ''make build'';
  installPhase = ''mkdir -p $out/bin && cp out $out/bin/bald'';

  meta = {
    description = "Simple C++ project build system";
    homepage = "https://github.com/NotBalds/bald";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ proggerx ];
    mainProgram = "bald";
  };
}
