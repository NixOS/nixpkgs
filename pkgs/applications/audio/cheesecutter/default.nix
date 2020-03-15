{ stdenv, lib, fetchFromGitHub, fetchpatch
, acme, ldc, patchelf
, SDL
}:

stdenv.mkDerivation rec {
  pname = "cheesecutter";
  version = "unstable-2019-12-06";

  src = fetchFromGitHub {
    owner = "theyamo";
    repo = "CheeseCutter";
    rev = "6b433c5512d693262742a93c8bfdfb353d4be853";
    sha256 = "1szlcg456b208w1237581sg21x69mqlh8cr6v8yvbhxdz9swxnwy";
  };

  nativeBuildInputs = [ acme ldc patchelf ];

  buildInputs = [ SDL ];

  patches = [
    ./0001-fix-impure-build-date-display.patch
  ];

  makefile = "Makefile.ldc";

  installPhase = ''
    for exe in {ccutter,ct2util}; do
      install -D $exe $out/bin/$exe
    done

    mkdir -p $out/share/cheesecutter/example_tunes
    cp -r tunes/* $out/share/cheesecutter/example_tunes
  '';

  postFixup = ''
    rpath=$(patchelf --print-rpath $out/bin/ccutter)
    patchelf --set-rpath "$rpath:${lib.makeLibraryPath buildInputs}" $out/bin/ccutter
  '';

  meta = with lib; {
    description = "A tracker program for composing music for the SID chip.";
    homepage = "https://github.com/theyamo/CheeseCutter/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
