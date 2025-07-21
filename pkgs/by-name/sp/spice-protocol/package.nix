{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "spice-protocol";
  version = "0.14.5";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-uvWESfbonRn0dYma1fuRlv3EbAPMUyM/TjnPKXj5z/c=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = "https://www.spice-space.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
