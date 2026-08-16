{
  stdenv,
  blender,
  makeWrapper,
  extraModules ? [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = blender.pname + "-wrapped";
  src = blender;

  inherit (blender) version meta;

  nativeBuildInputs = [
    blender.pythonPackages.wrapPython
    makeWrapper
  ];
  installPhase = ''
    mkdir $out/bin -p
    cp -r $src/share $out/share

    buildPythonPath "''${pythonPath[*]}"

    makeWrapper ${blender}/bin/blender $out/bin/blender \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : $program_PYTHONPATH
  '';

  pythonPath = extraModules;
})
