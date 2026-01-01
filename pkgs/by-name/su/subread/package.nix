{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "subread";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/subread/subread-${version}/subread-${version}-source.tar.gz";
    sha256 = "sha256-Y5LXxmgxzddn5YJRiSp5pRtvq47QupZxrV6F/xqwHqo=";
  };

  buildInputs = [
    zlib
  ];

  configurePhase = ''
    runHook preConfigure

    cd src
    cp Makefile.${if stdenv.hostPlatform.isLinux then "Linux" else "MacOS"} Makefile

    runHook postConfigure
  '';

  makeFlags = [ "CC_EXEC=cc" ];

  installPhase = ''
    mkdir $out
    cp -r ../bin $out
  '';

<<<<<<< HEAD
  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "High-performance read alignment, quantification and mutation discovery";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jbedo ];
=======
  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "High-performance read alignment, quantification and mutation discovery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jbedo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    homepage = "https://subread.sourceforge.net/";
  };

}
