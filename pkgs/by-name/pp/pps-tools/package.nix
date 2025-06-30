{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pps-tools";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "redlab-i";
    repo = "pps-tools";
    rev = "v${version}";
    sha256 = "sha256-eLLFHrCgOQzOtVxlAsZ5X91KK+vZiKMGL7zbQFiIZtI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $dev/include
    mkdir -p $out/{usr/bin,usr/include/sys}
    make install DESTDIR=$out
    mv $out/usr/bin/* $out/bin
    mv $out/usr/include/* $dev/include/
    rm -rf $out/usr/
  '';

  meta = with lib; {
    description = "User-space tools for LinuxPPS";
    homepage = "http://linuxpps.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sorki ];
  };
}
