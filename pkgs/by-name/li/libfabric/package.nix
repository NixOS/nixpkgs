{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  enablePsm2 ? (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux),
  libpsm2,
  enableOpx ? (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux),
  libuuid,
  numactl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfabric";
  version = "2.4.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = "libfabric";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-C8k1caArVPBTtSggvAM7S660HpP99y9vac7oyf+HW2c=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    lib.optionals enableOpx [
      libuuid
      numactl
    ]
    ++ lib.optionals enablePsm2 [ libpsm2 ];

  configureFlags = [
    (if enablePsm2 then "--enable-psm2=${libpsm2}" else "--disable-psm2")
    (if enableOpx then "--enable-opx" else "--disable-opx")
  ];

  meta = {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with lib.licenses; [
      gpl2
      bsd2
    ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bzizou ];
  };
})
