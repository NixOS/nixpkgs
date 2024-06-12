{ lib, stdenv, fetchurl, gtk2, libexif, pkg-config, texinfo }:

stdenv.mkDerivation rec {
  pname = "xzgv";
  version = "0.9.2";
  src = fetchurl {
    url = "mirror://sourceforge/xzgv/xzgv-${version}.tar.gz";
    sha256 = "17l1xr9v07ggwga3vn0z1i4lnwjrr20rr8z1kjbw71aaijxl18i5";
  };
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [ gtk2 libexif ];
  postPatch = ''
    substituteInPlace config.mk \
      --replace /usr/local $out
    substituteInPlace Makefile \
      --replace "all: src man" "all: src man info"
  '';
  preInstall = ''
    mkdir -p $out/share/{app-install/desktop,applications,info,pixmaps}
  '';
  meta = with lib; {
    homepage = "https://sourceforge.net/projects/xzgv/";
    description = "Picture viewer for X with a thumbnail-based selector";
    license = licenses.gpl2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
    mainProgram = "xzgv";
  };
}
