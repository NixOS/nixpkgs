{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avanor";
  version = "0.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/avanor/avanor/${finalAttrs.version}/avanor-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-j1W+g9mFRwuaUiAmP8h9CgpuK2DbvJd8HEk0cyE3nvM=";
  };

  strictDeps = true;

  buildInputs = [ ncurses ];

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++98"
    "-fpermissive"
  ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "CC=${stdenv.cc.targetPrefix}c++"
    "LD=${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    printf "Z" | ./avanor >/dev/null

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 avanor -t "$out/bin"
    install -Dm644 README.txt changes.txt -t "$out/share/doc/avanor"
    install -Dm644 manual/*.html manual/*.css -t "$out/share/doc/avanor/manual"
    install -Dm644 COPYING -t "$out/share/licenses/avanor"

    runHook postInstall
  '';

  meta = {
    description = "ADOM-like roguelike RPG for the terminal";
    homepage = "http://avanor.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "avanor";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
