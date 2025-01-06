{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ecos";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos";
    rev = version;
    sha256 = "1hsndim5kjvcwk5svqa4igawzahj982180xj1d7yd0dbjlgxc7w7";
  };

  buildPhase = ''
    make all shared
  '';

  doCheck = true;
  checkPhase = ''
    make test
    ./runecos
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp lib*.a lib*.so $out/lib
    cp -r include $out/
  '';

  meta = {
    description = "Lightweight conic solver for second-order cone programming";
    homepage = "https://www.embotech.com/ECOS";
    downloadPage = "https://github.com/embotech/ecos/releases";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
