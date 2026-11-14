{
  lib,
  stdenv,
  requireFile,
  gogUnpackHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nox-assets";
  version = "2.0.0.20";

  src = requireFile {
    name = "setup_nox_${finalAttrs.version}.exe";
    hash = "sha256-TbzPEzDb3cDAE0XbrReFnPy/bBEu0OWll0OFSRQKNwI=";
    message = ''
      In order to continue, you must first obtain a valid copy of Nox.

      Please purchase the game on gog.com and download the Windows installer, or obtain it
      from a physical copy.

      Once you have the installer, please run either of the following commands and re-run the
      installation:

      Either
        nix-store --add-fixed sha256 setup_nox_${finalAttrs.version}.exe
      or
        nix-prefetch-url --type sha256 file:///path/to/setup_nox_${finalAttrs.version}.exe
    '';
  };

  nativeBuildInputs = [ gogUnpackHook ];

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    cp -a app/. $out

    runHook postInstall
  '';

  meta = {
    description = "Assets for the game Nox";
    homepage = "https://gog.com/game/nox";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})
