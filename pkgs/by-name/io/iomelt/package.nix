{
  fetchurl,
  lib,
  stdenv,
}:

let
  version = "0.7";
in
stdenv.mkDerivation {
  inherit version;
  pname = "iomelt";
  src = fetchurl {
    url = "https://web.archive.org/web/20180816072405if_/http://iomelt.com/s/iomelt-${version}.tar.gz";
    sha256 = "1jhrdm5b7f1bcbrdwcc4yzg26790jxl4d2ndqiwd9brl2g5537im";
  };

  preBuild = ''
    install -d $out/{bin,share/man/man1}

    substituteInPlace Makefile \
      --replace /usr $out
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple yet effective way to benchmark disk IO in Linux systems";
    homepage = "https://github.com/camposr/iomelt";
    maintainers = with lib.maintainers; [ raspher ];
    license = lib.licenses.artistic2;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Simple yet effective way to benchmark disk IO in Linux systems";
    homepage = "https://github.com/camposr/iomelt";
    maintainers = with maintainers; [ raspher ];
    license = licenses.artistic2;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
