{
  bash,
  blender,
  callPackage,
  lib,
  runCommand,
  writeScriptBin,
}:

let
  blenderWithCuda = blender.override {cudaSupport = true;};
  name = "${blenderWithCuda.name}-check-cuda";
  unwrapped = writeScriptBin "${name}-unwrapped" ''
    #!${lib.getExe bash}
    ${lib.getExe blenderWithCuda} --background -noaudio --python-exit-code 1 --python ${./test-cuda.py}
  '';
in
{
  cudaAvailable =
    runCommand name
      {
        nativeBuildInputs = [unwrapped];
        requiredSystemFeatures = ["cuda"];
        passthru = {
          inherit unwrapped;
        };
      }
      "${name}-unwrapped && touch $out";
}
