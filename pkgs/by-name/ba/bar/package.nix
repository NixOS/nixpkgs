{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "bar";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/clpbar/clpbar/bar-${version}/bar_${version}.tar.gz";
    sha256 = "00v5cb6vzizyyhflgr62d3k8dqc0rg6wdgfyyk11c0s0r32mw3zs";
  };

  meta = with lib; {
    description = "Console progress bar";
    homepage = "https://clpbar.sourceforge.net/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.rdnetto ];
    platforms = platforms.all;
    mainProgram = "bar";
  };
}
