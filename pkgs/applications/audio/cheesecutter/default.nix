{ stdenv
, lib
, fetchFromGitHub
, acme
, ldc
, patchelf
, SDL
}:
stdenv.mkDerivation rec {
  pname = "cheesecutter";
  version = "unstable-2020-04-03";

  src = fetchFromGitHub {
    owner = "theyamo";
    repo = "CheeseCutter";
    rev = "68d6518f0e6249a2a5d122fc80201578337c1277";
    sha256 = "0xspzjhc6cp3m0yd0mwxncg8n1wklizamxvidrnn21jgj3mnaq2q";
  };

  patches = [
    ./0001-Drop-baked-in-build-date-for-r13y.patch
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin ./0002-Prepend-libSDL.dylib-to-macOS-SDL-loader.patch;

  nativeBuildInputs = [ acme ldc ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) patchelf;

  buildInputs = [ SDL ];

  makefile = "Makefile.ldc";

  installPhase = ''
    for exe in {ccutter,ct2util}; do
      install -D $exe $out/bin/$exe
    done

    mkdir -p $out/share/cheesecutter/example_tunes
    cp -r tunes/* $out/share/cheesecutter/example_tunes
  '';

  postFixup =
    let
      rpathSDL = lib.makeLibraryPath [ SDL ];
    in
    if stdenv.hostPlatform.isDarwin then ''
      install_name_tool -add_rpath ${rpathSDL} $out/bin/ccutter
    '' else ''
      rpath=$(patchelf --print-rpath $out/bin/ccutter)
      patchelf --set-rpath "$rpath:${rpathSDL}" $out/bin/ccutter
    '';

  meta = with lib; {
    description = "A tracker program for composing music for the SID chip";
    homepage = "https://github.com/theyamo/CheeseCutter/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
