{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ssh-tools";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "vaporup";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PDoljR/e/qraPhG9RRjHx1gBIMtTJ815TZDJws8Qg6o=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ssh-* $out/bin/
  '';

  meta = with lib; {
    description = "Collection of various tools using ssh";
    homepage = "https://github.com/vaporup/ssh-tools/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
