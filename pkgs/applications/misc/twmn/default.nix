{ stdenv, fetchgit, qtbase, qtx11extras, qmake, pkgconfig, boost }:

stdenv.mkDerivation rec {
  name = "twmn-git-2014-09-23";

  src = fetchgit {
    url = "https://github.com/sboli/twmn.git";
    rev = "9492a47e25547e602dd57efd807033677c90b150";
    sha256 = "1a68gka9gyxyzhc9rn8df59rzcdwkjw90cxp1kk0rdfp6svhxhsa";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtbase qtx11extras boost ];

  postPatch = ''
    sed -i s/-Werror// twmnd/twmnd.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "A notification system for tiling window managers";
    homepage = https://github.com/sboli/twmn;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    license = stdenv.lib.licenses.lgpl3;
  };
}
