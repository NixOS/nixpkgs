{ stdenv
, lib
, blender
, makeWrapper
, python3Packages
}:
{ name ? "wrapped"
, packages ? []
}:
stdenv.mkDerivation {
  pname = "blender-${name}";
  inherit (blender) version;
  src = blender;

  nativeBuildInputs = [ python3Packages.wrapPython makeWrapper ];
  installPhase = ''
    mkdir $out/{share/applications,bin} -p
    sed 's/Exec=blender/Exec=blender-${name}/g' $src/share/applications/blender.desktop > $out/share/applications/blender-${name}.desktop
    cp -r $src/share/blender $out/share
    cp -r $src/share/doc $out/share
    cp -r $src/share/icons $out/share

    buildPythonPath "$pythonPath"

    makeWrapper ${blender}/bin/blender $out/bin/blender-${name} \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : $program_PYTHONPATH
  '';

  pythonPath = packages;

  meta = blender.meta;
}
