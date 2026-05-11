{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "_7z-far";
  version = "26.01";

  src = fetchFromGitHub {
    owner = "ip7z";
    repo = "7zip";
    rev = "8c63d71ff886bda90c86db28466287f977374237";
    hash = "sha256-GCVZA0M7WGDyndHbnko62nQcLnb1YQYERs7U8G+yn2M=";
  };

  nativeBuildInputs = [ gcc ];

  buildPhase = ''
    make -C CPP/7zip/Bundles/Format7zF -f ../../cmpl_gcc.mak
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -r CPP/7zip/Bundles/Format7zF/b/g/* $out/lib/
  '';

  meta = with lib; {
    description = "7z format plugin from ip7z/7zip with 7z.so built for far2l";
    homepage = "https://github.com/ip7z/7zip";
    license = licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ tempergate ];
    platforms = platforms.unix;
  };
}