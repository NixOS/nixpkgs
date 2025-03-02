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

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "2.0.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W86hsxhbaUbB1sb0l1J0e/9IBnc5eZLQ1m4/SuyXZG0=";
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

  meta = with lib; {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with licenses; [
      gpl2
      bsd2
    ];
    platforms = platforms.all;
    maintainers = [ maintainers.bzizou ];
  };
}
