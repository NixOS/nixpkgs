{
  lib,
  stdenv,
  fetchFromGitHub,
  libarchive,
  iucode-tool,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "microcode-intel";
  version = "20250512";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    rev = "microcode-${version}";
    hash = "sha256-xasV1w6+8qnD+RLWsReMo+xm7a9nguV2st3IC4FURDU=";
  };

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    ${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe iucode-tool} -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    touch -d @$SOURCE_DATE_EPOCH kernel/x86/microcode/GenuineIntel.bin
    echo kernel/x86/microcode/GenuineIntel.bin | bsdtar --uid 0 --gid 0 -cnf - -T - | bsdtar --null -cf - --format=newc @- > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.intel.com/";
    changelog = "https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/${src.rev}";
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ felixsinger ];
  };
}
