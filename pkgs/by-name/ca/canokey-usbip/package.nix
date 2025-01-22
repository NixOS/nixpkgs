{
  cmake,
  fetchFromGitHub,
  lib,
  python3,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "canokey-usbip";
  version = "0-unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "canokeys";
    repo = "canokey-usbip";
    rev = "cc7087277096f185401b05143f9a028711d43557";
    hash = "sha256-+7sGW2eGelRQ2TDvgUITbPdcsXo7Pp6Pp+r3RmyQAZM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i 's/COMMAND git describe.*\(>>.*\)/COMMAND echo ${finalAttrs.src.rev} \1/' canokey-core/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=incompatible-pointer-types"
    ];
  };

  postInstall = ''
    install -D --target-directory=$out/bin canokey-usbip
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "CanoKey USB/IP Virt Card";
    homepage = "https://github.com/canokeys/canokey-usbip";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "canokey-usbip";
    platforms = lib.platforms.all;
  };
})
