{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  libarchive,
  iucode-tool,
  buildPackages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "microcode-intel";
  version = "20260210";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    tag = "microcode-${finalAttrs.version}";
    hash = "sha256-c5DAcaXO8FuZtbzrNwjS5E8JEKHb4rFo0CVm1xfDtcY=";
  };

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    ${stdenvNoCC.hostPlatform.emulator buildPackages} ${lib.getExe iucode-tool} -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    touch -d @$SOURCE_DATE_EPOCH kernel/x86/microcode/GenuineIntel.bin
    echo kernel/x86/microcode/GenuineIntel.bin | bsdtar --uid 0 --gid 0 -cnf - -T - | bsdtar --null -cf - --format=newc @- > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.intel.com/";
    changelog = "https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/${finalAttrs.src.rev}";
    description = "Microcode for Intel processors";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ felixsinger ];
  };
})
