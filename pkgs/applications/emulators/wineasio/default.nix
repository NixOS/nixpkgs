{ multiStdenv
, lib
, fetchFromGitHub
, libjack2
, pkg-config
, wineWowPackages
, pkgsi686Linux
}:

multiStdenv.mkDerivation rec {
  pname = "wineasio";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HEnJj9yfXe+NQuPATMpPvseFs+3TkiMLd1L+fIfQd+o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config wineWowPackages.stable ];

  buildInputs = [ pkgsi686Linux.libjack2 libjack2 ];

  dontConfigure = true;

  makeFlags = [ "PREFIX=${wineWowPackages.stable}" ];

  buildPhase = ''
    runHook preBuild
    make "''${makeFlags[@]}" 32
    make "''${makeFlags[@]}" 64
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D build32/wineasio.dll $out/lib/wine/i386-windows/wineasio.dll
    install -D build32/wineasio.dll.so $out/lib/wine/i386-unix/wineasio.dll.so
    install -D build64/wineasio.dll $out/lib/wine/x86_64-windows/wineasio.dll
    install -D build64/wineasio.dll.so $out/lib/wine/x86_64-unix/wineasio.dll.so
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wineasio/wineasio";
    description = "ASIO to JACK driver for WINE";
    license = with licenses; [ gpl2 lgpl21 ];
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
