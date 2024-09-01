{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-edit";
  version = "0-unstable-2024-09-03";

  src = fetchFromGitHub {
    owner = "velorek1";
    repo = "C-edit";
    rev = "cef44ae31ec4ee3495bd2b3f1d3a72c8b7d4164f";
    hash = "sha256-PwHndY2hhTBb0GdFt2MgIBkC4eK2MUJc9xUnV7l67OM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  installPhase = ''
    runHook preInstall

    install -Dm755 ./cedit -t $out/bin
    ln -s $out/bin/cedit $out/bin/c-edit

    runHook postInstall
  '';

  meta = {
    description = "Text editor in the style of the MSDOS EDIT, without using ncurses";
    homepage = "https://github.com/velorek1/c-edit";
    license = lib.licenses.mit;
    mainProgram = "cedit";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
