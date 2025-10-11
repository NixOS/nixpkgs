{
  lib,
  stdenv,
  fetchfossil,
  tcl,

  enableTcl ? true,
}:

stdenv.mkDerivation {
  pname = "pikchr";
  # To update, use the last check-in in https://pikchr.org/home/timeline?r=trunk
  version = "0-unstable-2025-05-12";

  src = fetchfossil {
    url = "https://pikchr.org/home";
    rev = "2972d1d24849d4c3";
    hash = "sha256-IZ9m1xa2bO9Sd6XYROkNz6PloLEbR3d3JpSSYyDJR8I=";
  };

  # can't open generated html files
  postPatch = ''
    substituteInPlace Makefile --replace open "test -f"
  '';

  nativeBuildInputs = lib.optional enableTcl tcl.tclPackageHook;

  buildInputs = lib.optional enableTcl tcl;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  buildFlags = [ "pikchr" ] ++ lib.optional enableTcl "piktcl";

  installPhase = ''
    runHook preInstall
    install -Dm755 pikchr $out/bin/pikchr
    install -Dm755 pikchr.out $out/lib/pikchr.o
    install -Dm644 pikchr.h $out/include/pikchr.h
  ''
  + lib.optionalString enableTcl ''
    cp -r piktcl $out/lib/piktcl
  ''
  + ''
    runHook postInstall
  '';

  dontWrapTclBinaries = true;

  doCheck = true;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "PIC-like markup language for diagrams in technical documentation";
    homepage = "https://pikchr.org";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "pikchr";
  };
}
