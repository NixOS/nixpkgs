{
  lib,
  runCommand,
  csound,
  csound-plugins,
  plugins,
}:

let
  opcodes = {
    chua = "chuap";
    dssi = "dssiinit";
    faust = "faustcompile";
    fluid = "fluidEngine";
    hdf5 = "hdf5read";
    image = "imageload";
    linear-algebra = "la_i_vr_create";
    opencl = "cladsyn";
    python = "pyinit";
    stk = "STKBeeThree";
    websocket = "websocket";
    wiimote = "wiiconnect";
  };
in
{
  load = runCommand "${csound-plugins.name}-load-test" { } ''
    export CS_USER_PLUGINDIR=${csound-plugins}/lib/csound/plugins64-7.0
    # Csound exits with status 1 after listing opcodes.
    ${csound}/bin/csound -z1 > opcodes 2>&1 || test "$?" -eq 1
    if grep -Ei 'warning:|error:|not loading' opcodes; then
      cat opcodes
      exit 1
    fi
    ${lib.concatMapStringsSep "\n" (name: "grep -w ${opcodes.${name}} opcodes") plugins}
    cp opcodes "$out"
  '';
}
// lib.optionalAttrs (lib.elem "faust" plugins) {
  faust = runCommand "csound-plugins-faust-test" { } ''
    export CS_USER_PLUGINDIR=${csound-plugins}/lib/csound/plugins64-7.0
    ${csound}/bin/csound -n -d ${./faust-test.csd}
    touch "$out"
  '';
}
