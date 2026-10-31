{
  lib,
  csound,
  runCommand,
  testers,
}:

{
  version = testers.testVersion {
    package = csound;
    version = lib.versions.majorMinor csound.version;
  };

  withPlugins =
    let
      withPlugins = csound.withPlugins (plugins: [
        plugins.fluid
        plugins.stk
      ]);
    in
    runCommand "csound-with-plugins-test" { } ''
      # Core plugins must still load alongside the selected plugins.
      # Listing opcodes exits with status 1 even on success.
      ${withPlugins}/bin/csound -z1 > opcodes 2>&1 || test "$?" -eq 1
      grep -w oscsendlo opcodes
      grep -w fluidEngine opcodes
      grep -w STKBeeThree opcodes

      # Keep plugins supplied by the caller in the search path.
      CS_USER_PLUGINDIR=${csound.plugins.chua}/lib/csound/plugins64-7.0 \
        ${withPlugins}/bin/csound -z1 > extra-opcodes 2>&1 || test "$?" -eq 1
      grep -w chuap extra-opcodes
      grep -w fluidEngine extra-opcodes

      # Exercise both the external library and STK's installed raw wave files.
      ${withPlugins}/bin/csound -d -W -o render.wav ${./test.csd}
      test -s render.wav
      mkdir -p "$out"
      cp opcodes extra-opcodes render.wav "$out/"
    '';
}
