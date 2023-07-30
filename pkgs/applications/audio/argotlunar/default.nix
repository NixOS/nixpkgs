 { pkgs } :

pkgs.stdenv.mkDerivation rec {
  pname = "argotlunar";
  version = "2.1.0";

  src = pkgs.fetchgit {
    url = "https://github.com/mourednik/argotlunar";
    rev = "1527d5dd753a7af32600ac677337469bbf1d40cd";
    sha256 = "sha256-U20ZUFrck/Y3GwqEnPZewnUN1YIFucgNsJJTMtWY3wE=";
  };

  buildInputs = [
    pkgs.alsa-lib
    pkgs.freetype
    pkgs.curl
    pkgs.pkg-config
    pkgs.cmake
    pkgs.xorg.libX11
    pkgs.xorg.libXrandr
    pkgs.xorg.libXinerama
    pkgs.xorg.libxshmfence
    pkgs.xorg.libXext
    pkgs.xorg.libXcursor
  ];

  configurePhase = ''
    export HOME=$TMPDIR
    cmake . -B cmake-build
  '';

  buildPhase = ''
    cmake --build cmake-build --target all
  '';

  installPhase = ''
    mkdir -p $out/lib/vst3
    mv /build/.vst3/Argotlunar.vst3 $out/lib/vst3/
  '';

  meta = with pkgs.lib; {
    homepage = "https://mourednik.github.io/argotlunar/";
    description = "A tool for creating surreal transformations of audio streams";
    license = licenses.gpl2;
    maintainers = with maintainers; [ betodealmeida ];
    platforms = [ "x86_64-linux" ];
  };
}
