{ lib, fetchurl, stdenv, libiconv, ncurses, lua }:

stdenv.mkDerivation rec {
  pname = "dit";
  version = "0.7";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "0cmbyzqfz2qa83cg8lpjifn34wmx34c5innw485zh4vk3c0k8wlj";
  };

  buildInputs = [ ncurses lua ]
    ++ lib.optional stdenv.isDarwin libiconv;

  # fix paths
  prePatch = ''
    patchShebangs tools/GenHeaders
    substituteInPlace Prototypes.h --replace 'tail' "$(type -P tail)"
  '';

  meta = with stdenv.lib; {
    description = "A console text editor for Unix that you already know how to use";
    homepage = "https://hisham.hm/dit/";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ davidak ];
  };
}
