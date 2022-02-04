{ stdenv
, lib
, blender
, makeWrapper
, python39Packages
}:
{ name ? "wrapped"
, packages ? []
}:
stdenv.mkDerivation {
  pname = "blender-${name}";
  inherit (blender) version;
  src = blender;

  nativeBuildInputs = [ python39Packages.wrapPython makeWrapper ];
  installPhase = ''
    mkdir $out/{share/applications,bin} -p
    sed 's/Exec=blender/Exec=blender-${name}/g' $src/share/applications/blender.desktop > $out/share/applications/blender-${name}.desktop
    cp -r $src/share/blender $out/share
    cp -r $src/share/doc $out/share
    cp -r $src/share/icons $out/share

    buildPythonPath "$pythonPath"

    echo '#!/usr/bin/env bash ' >> $out/bin/blender-${name}
    for p in $program_PATH; do
      echo "export PATH=\$PATH:$p " >> $out/bin/blender-${name}
    done
    for p in $program_PYTHONPATH; do
      echo "export PYTHONPATH=\$PYTHONPATH:$p " >> $out/bin/blender-${name}
    done
    echo 'exec ${blender}/bin/blender "$@"' >> $out/bin/blender-${name}
    chmod +x $out/bin/blender-${name}
  '';

  pythonPath = packages;

  meta = blender.meta;
}
