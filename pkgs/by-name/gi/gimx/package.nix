{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  curl,
  libusb1,
  bluez,
  libxml2,
  ncurses5,
  libmhash,
  xorg,
}:

let
  gimx-config = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX-configurations";
    rev = "c20300f24d32651d369e2b27614b62f4b856e4a0";
    hash = "sha256-t/Ttlvc9LCRW624oSsFaP8EmswJ3OAn86QgF1dCUjAs=";
  };

in
stdenv.mkDerivation rec {
  pname = "gimx";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "matlo";
    repo = "GIMX";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BcFLdQgEAi6Sxyb5/P9YAIkmeXNZXrKcOa/6g817xQg=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  patches = [
    ./conf.patch
    ./gcc14.patch
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    curl
    libusb1
    bluez
    libxml2
    ncurses5
    libmhash
    xorg.libX11
    xorg.libXi
  ];
  makeFlags = [ "build-core" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    substituteInPlace ./core/Makefile --replace-fail "chmod ug+s" "echo"
    export DESTDIR="$out"
    make install-shared install-core
    mv $out/usr/lib $out/lib
    mv $out/usr/bin $out/bin
    cp -r ${gimx-config}/Linux $out/share

    makeWrapper $out/bin/gimx $out/bin/gimx-ds4 \
      --add-flags "--nograb" --add-flags "-p /dev/ttyUSB0" \
      --add-flags "-c $out/share/Dualshock4.xml"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/matlo/GIMX";
    description = "Game Input Multiplexer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
