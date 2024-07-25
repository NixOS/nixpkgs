{ stdenv
, lib
, blender
, makeWrapper
, extraModules ? []
}:
stdenv.mkDerivation (finalAttrs: {
  pname = blender.pname + "-wrapped";
  src = blender;

  inherit (blender) version meta;

  nativeBuildInputs = [ blender.pythonPackages.wrapPython makeWrapper ];
  installPhase = ''
    mkdir $out/{share/applications,bin} -p
    sed 's/Exec=blender/Exec=${finalAttrs.finalPackage.pname}/g' $src/share/applications/blender.desktop > $out/share/applications/${finalAttrs.finalPackage.pname}.desktop
    cp -r $src/share/blender $out/share
    cp -r $src/share/doc $out/share
    cp -r $src/share/icons $out/share

    buildPythonPath "$pythonPath"

    makeWrapper ${blender}/bin/blender $out/bin/${finalAttrs.finalPackage.pname} \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : $program_PYTHONPATH
  '';

  pythonPath = extraModules;
})
