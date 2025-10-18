{
  lib,
  stdenvNoCC,
  fetchFromGitHub,

  amd-ucodegen,
  microcode-amd,
  libarchive,

  nix-update-script,

  # CPU families to include in the final image
  # The decimal number of the CPU family can be optained with
  # `cat /proc/cpuinfo | grep family`
  # See also https://en.wikipedia.org/wiki/List_of_AMD_CPU_microarchitectures#Nomenclature
  withFamily15h ? true, # Decimal 21
  withFamily16h ? true, # Decimal 22
  withFamily17h ? true, # Decimal 23
  withFamily19h ? true, # Decimal 25
  withFamily1Ah ? true, # Decimal 26
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "microcode-amd-platomav";
  version = "0-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "platomav";
    repo = "CPUMicrocodes";
    rev = "ae2c33ecd7a5855a743b360a05bc984911d16957";
    hash = "sha256-HMq/XjTY/Dmjzufho8dw8bL/2iMlcIZEUcJI84o6/no=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    amd-ucodegen
    libarchive
  ];

  buildPhase = ''
    runHook preBuild

  ''
  + lib.optionalString withFamily15h ''
    amd-ucodegen AMD/cpu??6??F??_*
  ''
  + lib.optionalString withFamily16h ''
    amd-ucodegen AMD/cpu??7??F??_*
  ''
  + lib.optionalString withFamily17h ''
    amd-ucodegen AMD/cpu??8??F??_*
  ''
  + lib.optionalString withFamily19h ''
    amd-ucodegen AMD/cpu??A??F??_*
  ''
  + lib.optionalString withFamily1Ah ''
    amd-ucodegen AMD/cpu??B??F??_*
  ''
  + ''

    # Similar to microcodeAmd package
    mkdir -p kernel/x86/microcode
    find ./ -name microcode_amd\*.bin -print0 | sort -z |\
      xargs -0 -I{} sh -c 'cat {} >> kernel/x86/microcode/AuthenticAMD.bin'

    runHook postBuild
  '';

  inherit (microcode-amd) installPhase;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Microcode update image for AMD CPUs from platomav's github";
    homepage = "https://github.com/platomav/CPUMicrocodes";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
