{
  lib,
  stdenv,
  icoutils,
}:

stdenv.mkDerivation {
  pname = "icon-conv-tools";
  version = "0.0.0";

  src = ./bin;

  buildInputs = [ icoutils ];

  patchPhase = ''
    substituteInPlace extractWinRscIconsToStdFreeDesktopDir.sh \
      --replace "icotool" "${icoutils}/bin/icotool" \
      --replace "wrestool" "${icoutils}/bin/wrestool"
  '';

  buildPhase = ''
    mkdir -p "$out/bin"
    cp -p * "$out/bin"
  '';

  installPhase = "true";

  dontPatchELF = true;
  dontStrip = true;

  meta = {
    description = "Tools for icon conversion specific to nix package manager";
    maintainers = with lib.maintainers; [ jraygauthier ];
    platforms = lib.platforms.unix;
  };
}
