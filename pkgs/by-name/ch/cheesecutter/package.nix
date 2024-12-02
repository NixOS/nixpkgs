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
  version = "unstable-2021-02-27";

  src = fetchFromGitHub {
    owner = "theyamo";
    repo = "CheeseCutter";
    rev = "84450d3614b8fb2cabda87033baab7bedd5a5c98";
    sha256 = "sha256:0q4a791nayya6n01l0f4kk497rdq6kiq0n72fqdpwqy138pfwydn";
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

    install -Dm444 arch/fd/ccutter.desktop -t $out/share/applications
    for res in $(ls icons | sed -e 's/cc//g' -e 's/.png//g'); do
      install -Dm444 icons/cc$res.png $out/share/icons/hicolor/''${res}x''${res}/apps/cheesecutter.png
    done
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
    description = "Tracker program for composing music for the SID chip";
    homepage = "https://github.com/theyamo/CheeseCutter/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
