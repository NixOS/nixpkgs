{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "qboot";
  version = "unstable-2020-04-23";

  src = fetchFromGitHub {
    owner = "bonzini";
    repo = "qboot";
    rev = "de50b5931c08f5fba7039ddccfb249a5b3b0b18d";
    sha256 = "1d0h29zz535m0pq18k3aya93q7lqm2858mlcp8mlfkbq54n8c5d8";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  installPhase = ''
    mkdir -p $out
    cp bios.bin bios.bin.elf $out/.
  '';

  hardeningDisable = [
    "stackprotector"
    "pic"
  ];

  passthru.tests = {
    qboot = nixosTests.qboot;
  };

  meta = {
    description = "A simple x86 firmware for booting Linux";
    homepage = "https://github.com/bonzini/qboot";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
