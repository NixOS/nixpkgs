{ lib, stdenv, callPackage, fetchurl
, autoPatchelfHook, gnutar, glibc, gcc-unwrapped, zlib, fuse
}:

stdenv.mkDerivation rec {
  name = "jetbrains-toolbox-${version}";
  version = "1.17.6802";
  description = "Manage your JetBrains IDEs";

  dontStrip = true;

  src = fetchurl {
    # https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.6802.tar.gz
    url = "https://download.jetbrains.com/toolbox/${name}.tar.gz";
    sha256 = "65a7e446c339de361bf713880b2fb3953de8adeb95a10c9bb4100fcbb249cdf2";
  };

  nativeBuildInputs = [
    fuse
    glibc
    zlib
    gnutar
    autoPatchelfHook
  ];

  # Required at running time
  buildInputs = [
    fuse
    glibc
    zlib
    glibc
    gcc-unwrapped
  ];

  

  unpackPhase = ''
    mkdir jetbrains-toolbox
    tar -zxvf $src -C jetbrains-toolbox --strip-components 1
  '';

  installPhase = ''
    ls -lsah
    ls -lsah $src
    ls -lsah jetbrains-toolbox
    install -m755 -D jetbrains-toolbox/jetbrains-toolbox $out/jetbrains-toolbox
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.jetbrains.com/toolbox-app/";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
