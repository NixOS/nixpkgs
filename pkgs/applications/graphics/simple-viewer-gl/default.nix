{ stdenv
, fetchFromBitbucket
, pkg-config
, cmake
, glfw3
, libjpeg
, libpng
, lcms2
, zlib
, libexif
, libXrandr
, libXcursor
, giflib
, libtiff
, libwebp
, ilmbase
, openexr
, openjpeg
, imlib2
, curl
}:

stdenv.mkDerivation rec {
  pname = "simple-viewer-gl";
  version = "3.1.7";

  src = fetchFromBitbucket {
    owner = "andreyu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kqv1lcv32r7y9507gdb4frnm9l24qchpxygccdgahsd5lgri1ab";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    giflib
    glfw3
    ilmbase
    imlib2
    lcms2
    libXcursor
    libXrandr
    libexif
    libjpeg
    libpng
    libtiff
    libwebp
    openexr
    openjpeg
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -D -m0755 -t $out/bin sviewgl
    pushd .. >/dev/null
    install -D -m0644 -t $out/share/doc/ config.example README.md Copying.txt
    install -D -m0644 -t $out/share/applications/ sviewgl.desktop
    install -D -m0644 -t $out/share/icons/ res/Icon-1024.png
    popd >/dev/null
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tiny image viewer based on OpenGL";
    homepage = "https://www.ugolnik.info/simple-viewer-gl";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ caadar ];
  };

}
