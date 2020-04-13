{ stdenv
, autoPatchelfHook
, dpkg
, fetchurl
, freeglut
, gcc-unwrapped
, libGL
, libGLU
, makeWrapper
, zlib
}:
let
  majMin = stdenv.lib.versions.majorMinor version;
  version = "7.5.1";
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "fahviewer";

  src = fetchurl {
    url = "https://download.foldingathome.org/releases/public/release/fahviewer/debian-stable-64bit/v${majMin}/fahviewer_${version}_amd64.deb";
    hash = "sha256-yH0zGjX8aNBEJ5lq7wWydcpp2rO+9Ah++q9eJ+ldeyk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    freeglut
    gcc-unwrapped.lib
    libGL
    libGLU
    zlib
  ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
    sed -e 's|/usr/bin|$out/bin|g' -i usr/share/applications/FAHViewer.desktop
  '';

  installPhase = ''
    cp -ar usr $out
  '';

  meta = {
    description = "Folding@home viewer";
    homepage = "https://foldingathome.org/";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
