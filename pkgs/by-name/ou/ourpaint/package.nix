{ lib
, stdenv
, fetchzip
, cmake
, lagui
, lcms2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ourpaint";
  version = "0.1";

  src = fetchzip {
    url = "https://www.wellobserve.com/Files/OurPaint/Releases/OurPaint_src_v${finalAttrs.version}.tar.gz";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    lagui
    lcms2
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 OurPaint $out/bin/OurPaint
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.wellobserve.com/?post=20221222155743";
    description = "A featureless but programmable painting program";
    license = lib.licenses.gpl3Plus;
    # https://github.com/NixOS/nixpkgs/pull/209448#issuecomment-1374716174
    platforms = with lib; intersectLists (intersectLists platforms.littleEndian platforms."64bit") platforms.linux;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
