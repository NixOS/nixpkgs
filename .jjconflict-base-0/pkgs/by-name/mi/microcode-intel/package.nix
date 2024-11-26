{
  lib,
  stdenv,
  fetchFromGitHub,
  libarchive,
  iucode-tool,
}:

stdenv.mkDerivation rec {
  pname = "microcode-intel";
  version = "20241112";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    rev = "microcode-${version}";
    hash = "sha256-dvXt4SX/90oFM4GR9R7C2udhZ+plxnabOZpbtwN3V8Q=";
  };

  nativeBuildInputs = [
    iucode-tool
    libarchive
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
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
