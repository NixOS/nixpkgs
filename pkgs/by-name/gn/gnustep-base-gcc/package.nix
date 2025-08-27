{
  lib,
  gobjcStdenv,
  gnustep-make-gcc,
  gnustep-base,
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-base-gcc";
  inherit (gnustep-base) version src outputs nativeBuildInputs buildInputs propagatedBuildInputs patches;

  propagatedNativeBuildInputs = [
    gnustep-make-gcc
  ];

  meta = {
    inherit (gnustep-base.meta) changelog homepage license platforms;
    description = "Implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa (GCC Environment)";
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
  };
})
