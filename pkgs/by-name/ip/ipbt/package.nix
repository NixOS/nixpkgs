{
  lib,
  stdenv,
  fetchurl,
  perl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "20210215.5a9cb02";
  pname = "ipbt";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-${finalAttrs.version}.tar.gz";
    sha256 = "0w6blpv22jjivzr58y440zv6djvi5iccdmj4y2md52fbpjngmsha";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ ncurses ];

  meta = {
    description = "High-tech ttyrec player for Unix";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tckmn ];
    platforms = lib.platforms.unix;
    mainProgram = "ipbt";
  };
})
