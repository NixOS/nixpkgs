{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "dotcopy";
  version = "0.2.9";

  src = fetchzip {
    url = "https://github.com/firesquid6/dotcopy/releases/download/v${version}/dotcopy-v${version}-linux-amd64.tar.gz";
    hash = "sha256-QBEGtE7r5B39cILAg+Ev1cwfu4nXiMk2jn1NZVFHnyk=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv dotcopy $out/bin
  '';

  meta = with lib; {
    description = "A linux dotfile manager";
    homepage = "https://dotcopy.firesquid.co";
    license = licenses.gpl3;
    longDescription = ''
      Dotcopy is a linux dotfile manager that allows you to "compile" your dotfiles to use the same template for multiple machines.
    '';
    maintainers = with maintainers; [ firesquid6 ];
  };
}
