{
  lib,
  stdenvNoCC,
  requireFile,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "d3dmetal";
  version = "1.1";

  src = requireFile {
    name = "Game_Porting_Toolkit_${finalAttrs.version}.dmg";
    hash = "sha256-KoZRjX/OicMEJmZUp2EH05Wpp1VyJQlrc6g0iTSCt/E=";
    url = "https://developer.apple.com/download/all/?q=game%20porting%20toolkit";
  };

  strictDeps = true;

  nativeBuildInputs = [ undmg ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/lib/wine/x86_64-"{unix,windows}
    cp -r lib/external "$out/lib"
    for dll_so in atidxx64 d3d9 d3d10 d3d11 d3d12 dxgi; do
      ln -s "$out/lib/external/libd3dshared.dylib" "$out/lib/wine/x86_64-unix/$dll_so.so"
    done
    cp -r lib/wine/x86_64-windows "$out/lib/wine"
  '';

  meta = with lib; {
    description = "The D3D Metal component of Apple’s Gaming Porting Toolkit for use with Wine.";
    license = licenses.unfree;
    maintainers = [ maintainers.reckenrode ];
    platforms = [ "x86_64-darwin" ];
  };
})
