{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "bonnie++";
  version = "2.00a";

  src = fetchurl {
    url = "https://www.coker.com.au/bonnie++/bonnie++-${version}.tgz";
    hash = "sha256-qNM7vYG8frVZzlv25YS5tT+uo5zPtK6S5Y8nJX5Gjw4=";
  };

  patches = [
    (fetchpatch {
      name = "bonnie++-2.00a-gcc11.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-benchmarks/bonnie++/files/bonnie++-2.00a-gcc11.patch?id=d0f29755e969c805fbd6240905e3925671340666";
      hash = "sha256-/cIC4HYQco5Nv1UoTELl2OGD5hdWhbz3L0+GjN/vcdE=";
    })
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Hard drive and file system benchmark suite";
    homepage = "http://www.coker.com.au/bonnie++/";
    license = lib.licenses.gpl2Only;
    mainProgram = "bonnie++";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
