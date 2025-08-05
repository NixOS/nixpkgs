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
    runHook preBuild

    mkdir -p "$out/bin"
    cp -p * "$out/bin"

    runHook postBuild
  '';

  installPhase = "true";

  dontPatchELF = true;
  dontStrip = true;

  meta = with lib; {
    description = "Tools for icon conversion specific to nix package manager";
    maintainers = with maintainers; [ jraygauthier ];
    platforms = platforms.unix;
  };
}
