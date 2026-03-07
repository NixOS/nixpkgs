{
  lib,
  stdenv,
  fetchFromGitHub,
  libmnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfptpd";
  version = "3.9.0.1007";

  src = fetchFromGitHub {
    owner = "Xilinx-CNS";
    repo = "sfptpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DyBKcsQCAtAkqX7ud5DV1J1yaPrFTmE074Yotq17VCA=";
  };

  buildInputs = [ libmnl ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    for f in sfptpd sfptpdctl; do
      install -Dm755 build/"$f" "$out"/bin/"$f"
    done

    runHook postInstall
  '';

  meta = {
    description = "Solarflare Enhanced PTP Daemon - precision time synchronization for Xilinx/Solarflare NICs";
    homepage = "https://github.com/Xilinx-CNS/sfptpd";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.freeman94 ];
    platforms = lib.platforms.linux;
    mainProgram = "sfptpd";
  };
})
