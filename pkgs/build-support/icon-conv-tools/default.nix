{ stdenv, icoutils }:

stdenv.mkDerivation {
  name = "icon-conv-tools-0.0.0";

  src = ./.;

  buildInputs = [ icoutils ];

  patchPhase = ''
    substituteInPlace "./bin/extractWinRscIconsToStdFreeDesktopDir.sh" \
      --replace "icotool" "${icoutils}/bin/icotool" \
      --replace "wrestool" "${icoutils}/bin/wrestool"
  '';

  buildPhase = ''
    mkdir -p "$out/bin"
    cp -p "./bin/"* "$out/bin"
  '';

  installPhase = "true";
  
  dontPatchELF = true;
  dontStrip = true;

  meta = {
    description = "Tools for icon conversion specific to nix package manager";
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };

}