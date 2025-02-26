{ lib
, stdenv
, fetchFromGitea
, cmake
, lagui
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "ourpaint";
  version = "unstable-2023-01-26";

  src = fetchFromGitea {
    domain = "www.wellobserve.com/repositories";
    owner = "chengdulittlea";
    repo = "OurPaint";
    rev = "7c8cb7f5ecbd9f94f19455ca31f83c818411da2b";
    hash = "sha256-iwBfnmT6E4lZXRnzWK2fxgirBpBtsYg9fMF8+5zUQXI=";
  };
  # On next release:
  #src = fetchzip {
  #  url = "https://www.wellobserve.com/Files/OurPaint/Releases/OurPaint_src_v${version}.tar.gz";
  #  hash = lib.fakeHash;
  #};

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

  meta = with lib; {
    homepage = "https://www.wellobserve.com/?post=20221222155743";
    description = "A featureless but programmable painting program";
    license = licenses.gpl3Plus;
    # https://github.com/NixOS/nixpkgs/pull/209448#issuecomment-1374716174
    platforms = intersectLists (intersectLists platforms.littleEndian platforms."64bit") platforms.linux;
    maintainers = with maintainers; [ fgaz ];
  };
}
