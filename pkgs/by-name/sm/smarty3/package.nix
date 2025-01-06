{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "smarty3";
  version = "3.1.48";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${version}";
    hash = "sha256-QGhccIJ7BZTWGF+n8rmB1RCVyJKID95NW6Yb2VvqqGQ=";
  };

  installPhase = ''
    mkdir $out
    cp -r libs/* $out
  '';

  meta = with lib; {
    description = "Smarty 3 template engine";
    longDescription = ''
      Smarty is a template engine for PHP, facilitating the
      separation of presentation (HTML/CSS) from application
      logic. This implies that PHP code is application
      logic, and is separated from the presentation.
    '';
    homepage = "https://www.smarty.net";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ das_j ];
  };
}
