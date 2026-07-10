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
  version = "unstable-2022-09-19";

  src = fetchFromGitHub {
    owner = "bonzini";
    repo = "qboot";
    rev = "8ca302e86d685fa05b16e2b208888243da319941";
    hash = "sha256-YxVGFiyLdhq7yWaXARh7f0nBZgXfJuYvv1BxfyThupM=";
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

  passthru.tests.qboot = nixosTests.qboot;

  meta = {
    description = "Simple x86 firmware for booting Linux";
    homepage = "https://github.com/bonzini/qboot";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
