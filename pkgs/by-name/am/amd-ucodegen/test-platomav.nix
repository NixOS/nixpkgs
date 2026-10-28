{
  stdenvNoCC,
  fetchFromGitHub,
  amd-ucodegen,
}:

stdenvNoCC.mkDerivation {
  name = "amd-ucodegen-test-platomav";
  meta.timeout = 60;

  # Repository of dumped CPU microcodes
  src = fetchFromGitHub {
    owner = "platomav";
    repo = "CPUMicrocodes";
    rev = "dfc37d654cbe294acb0ec0274763321507dd7838";
    hash = "sha256-Va+ErKID5iyKEee61tlrZwSpujxwMYPC+MAgZKUkrrM=";
  };

  nativeBuildInputs = [ amd-ucodegen ];
  buildPhase = ''
    runHook preBuild

    echo -n "Test normal behavior with single input... "
    [ "$(amd-ucodegen AMD/cpu00B40F40_ver0B40401A_2024-06-14_544DFCB8.bin)" \
      == "CPU type 0xb40f40 [0xb440], file AMD/cpu00B40F40_ver0B40401A_2024-06-14_544DFCB8.bin" ]
    echo "OK"
    echo -n "Check output hash... "
    [ "$(sha256sum microcode_amd_fam1ah.bin)" \
      == "17f25ec78fa677803684e77ce01a21344b4b33463a964f61bae51b173543b190  microcode_amd_fam1ah.bin" ]
    echo "OK"
    echo -n "Ensure fail when bad processor ID... "
    [ "$(amd-ucodegen AMD/cpu00000F00_ver02000008_2007-06-14_C3A923BB.bin 2>&1)" \
      == "Bad processor ID 0x0n" ]
    echo "OK"

    touch $out

    runHook postBuild
  '';
}
