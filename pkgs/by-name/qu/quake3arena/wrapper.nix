{
  stdenv,
  buildEnv,
  lib,
  libGL,
  ioquake3,
  makeWrapper,
}:

{
  paks,
  pname ? (lib.head paks).pname,
  version ? (lib.head paks).version,
  description ? "",
}:

let
  libPath = lib.makeLibraryPath [
    libGL
    stdenv.cc.cc
  ];
  env = buildEnv {
    name = "quake3-env";
    paths = [ ioquake3 ] ++ paks;
  };

in
stdenv.mkDerivation {
  pname = "${pname}-${ioquake3.name}";
  inherit version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand =
    let
      setBasepath = "+set fs_basepath ${env}";
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin

      # We add Mesa to the end of $LD_LIBRARY_PATH to provide fallback
      # software rendering. GCC is needed so that libgcc_s.so can be found
      # when Mesa is used.
      makeWrapper ${env}/bin/ioquake3 $out/bin/${pname} \
        --suffix-each LD_LIBRARY_PATH ':' "${libPath}" \
        --add-flags "${setBasepath} +set r_allowSoftwareGL 1"

      makeWrapper ${env}/bin/ioq3ded $out/bin/${pname}-server \
        --add-flags "${setBasepath}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      makeWrapper ${env}/bin/ioquake3 $out/bin/${pname} \
        --add-flags "${setBasepath}"
      makeWrapper ${env}/bin/ioq3ded $out/bin/${pname}-server \
        --add-flags "${setBasepath}"

      cp -RL ${env}/Applications/ioquake3.app/ $out/Applications/${pname}.app
      chmod -R +w $out/Applications/

      wrapProgram $out/Applications/${pname}.app/Contents/MacOS/ioquake3 \
        --add-flags "${setBasepath}"
      wrapProgram $out/Applications/${pname}.app/Contents/MacOS/ioq3ded \
        --add-flags "${setBasepath}"
    '';

  meta = {
    mainProgram = "${pname}";
    inherit ((lib.head paks).meta)
      description
      longDescription
      homepage
      license
      ;
    inherit (ioquake3.meta) platforms;
  };
}
