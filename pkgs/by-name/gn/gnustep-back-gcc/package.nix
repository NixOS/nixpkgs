{
  lib,
  gobjcStdenv,
  gnustep-gui-gcc,
  gnustep-back,
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  inherit (gnustep-back) version src nativeBuildInputs buildInputs;
  pname = "gnustep-back-gcc";

  propagatedBuildInputs = [ gnustep-gui-gcc ];

  meta = {
    description = "Generic backend for GNUstep (GCC environment)";
    inherit (gnustep-back.meta) mainProgram homepage license platforms;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
  };
})
