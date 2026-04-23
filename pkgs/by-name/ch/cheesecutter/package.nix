{
  stdenv,
  lib,
  fetchFromGitHub,
  acme,
  ldc,
  patchelf,
  SDL,
}:
stdenv.mkDerivation {
  pname = "cheesecutter";
  version = "2.9-beta-3-unstable-2021-02-27";

  src = fetchFromGitHub {
    owner = "theyamo";
    repo = "CheeseCutter";
    rev = "84450d3614b8fb2cabda87033baab7bedd5a5c98";
    hash = "sha256-tnnuLhrBY34bduJYgOM0uOWTyJzEARqANcp7ZUM6imA=";
  };

  patches = [
    # https://github.com/theyamo/CheeseCutter/pull/60
    ./1001-cheesecutter-Pin-C-standard-to-C99.patch

    ./0001-Drop-baked-in-build-date-for-r13y.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./0002-Prepend-libSDL.dylib-to-macOS-SDL-loader.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    acme
    ldc
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    patchelf
  ];

  buildInputs = [ SDL ];

  enableParallelBuilding = true;

  makefile = "Makefile.ldc";

  installPhase = ''
    runHook preInstall

    for exe in {ccutter,ct2util}; do
      install -D $exe $out/bin/$exe
    done

    mkdir -p $out/share/cheesecutter/example_tunes
    cp -r tunes/* $out/share/cheesecutter/example_tunes

    install -Dm444 arch/fd/ccutter.desktop -t $out/share/applications
    for res in $(ls icons | sed -e 's/cc//g' -e 's/.png//g'); do
      install -Dm444 icons/cc$res.png $out/share/icons/hicolor/''${res}x''${res}/apps/cheesecutter.png
    done

    runHook postInstall
  '';

  postFixup =
    let
      rpathSDL = lib.makeLibraryPath [ SDL ];
    in
    if stdenv.hostPlatform.isDarwin then
      ''
        install_name_tool -add_rpath ${rpathSDL} $out/bin/ccutter
      ''
    else
      ''
        rpath=$(patchelf --print-rpath $out/bin/ccutter)
        patchelf --set-rpath "$rpath:${rpathSDL}" $out/bin/ccutter
      '';

  meta = {
    description = "Tracker program for composing music for the SID chip";
    homepage = "https://github.com/theyamo/CheeseCutter/";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "ccutter";
  };
}
