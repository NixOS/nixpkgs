{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "common-licenses";
  version = "13";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/b/base-files/base-files_${version}.tar.xz";
    hash = "sha256-Q5FTvfKWSBE1ywuAH+RnZdyD+LmRSgJ11qFiM53hL1Y=";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r licenses $out/share/common-licenses
    cat debian/base-files.links | grep common-licenses | sed -e "s|usr|$out|g" -e "s|^|ln -s |g" | bash -x
  '';

  meta = with lib; {
    description = "common-licenses extracted from debian base-files package";
    homepage = "https://tracker.debian.org/pkg/base-files";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
