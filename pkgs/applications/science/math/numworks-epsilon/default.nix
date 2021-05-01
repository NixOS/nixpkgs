{ stdenv
, lib
, fetchFromGitHub
, libpng
, xorg
, python3
, imagemagick
, gcc-arm-embedded
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "numworks-epsilon";
  version = "15.3.2";

  src = fetchFromGitHub {
    owner = "numworks";
    repo = "epsilon";
    rev = version;
    sha256 = "1q34dilyypiggjs16486jm122yf20wcigqxvspc77ig9albaxgh5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpng
    xorg.libXext
    python3
    imagemagick
    gcc-arm-embedded
  ];

  makeFlags = [
    "PLATFORM=simulator"
  ];

  installPhase = ''
    runHook preInstall

    mv ./output/release/simulator/linux/{epsilon.bin,epsilon}
    mkdir -p $out/bin
    cp -r ./output/release/simulator/linux/* $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Emulator for Epsilon, a High-performance graphing calculator operating system";
    homepage = "https://numworks.com/";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ erikbackman ];
    platforms = [ "x86_64-linux" ];
  };
}
