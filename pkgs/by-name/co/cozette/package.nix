{
  lib,
  stdenvNoCC,
  fetchzip,
  writeText,
  bdf2psf,
  codepoints ? (import ./default-codepoints.nix),
}:

let
  codepoints_set = writeText "codepoints.set" (builtins.concatStringsSep "\n" codepoints);
in
stdenvNoCC.mkDerivation rec {
  pname = "cozette";
  version = "1.30.0";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts-v-${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }.zip";
    hash = "sha256-Njh6V5wTBKM/1QKmPwG1qiOYyAJSVQXLTBLN03V6DaE=";
  };

  nativeBuildInputs = [ bdf2psf ];

  postBuild = ''
    # Confine Powerline left divider symbols to strictly 6 pixels wide
    awk -i inplace 'BEGIN { l=-128 } $1=="ENCODING"&&($2==57520||$2==57521||$2==57524) { l=FNR } l+4<FNR&&FNR<=l+17 { printf("%02X\n", and(lshift(strtonum("0x"$1), 1), 0xFF)); next; }{ print }' cozette.bdf
    awk -i inplace 'BEGIN { l=-128 } $1=="ENCODING"&&($2==57520||$2==57521||$2==57524) { l=FNR } l+4<FNR&&FNR<=l+30 { printf("%04X\n", and(lshift(strtonum("0x"$1), 1), 0xFFFF)); next; }{ print }' cozette_hidpi.bdf

    # Fix for bdf2psf limitation (See https://github.com/slavfox/Cozette/issues/122#issuecomment-2165328416)
    sed -i -e 's/^BBX [2-8]/BBX 9/g' cozette_hidpi.bdf

    bdf2psf --fb cozette.bdf ${bdf2psf}/share/bdf2psf/standard.equivalents ${codepoints_set} 512 cozette6x13.psfu
    bdf2psf --fb cozette_hidpi.bdf ${bdf2psf}/share/bdf2psf/standard.equivalents ${codepoints_set} 512 cozette12x26.psfu
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.otf -t $out/share/fonts/opentype
    install -Dm644 *.bdf -t $out/share/fonts/misc
    install -Dm644 *.otb -t $out/share/fonts/misc
    install -Dm644 *.woff -t $out/share/fonts/woff
    install -Dm644 *.woff2 -t $out/share/fonts/woff2

    install -Dm644 *.psfu -t "$out/share/consolefonts/"

    runHook postInstall
  '';

  meta = {
    description = "Bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
    changelog = "https://github.com/slavfox/Cozette/blob/v.${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ brettlyons ];
  };
}
