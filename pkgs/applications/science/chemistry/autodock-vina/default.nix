{
  lib,
  stdenv,
  fetchFromGitHub,
  boost186,
  glibc,
}:
let
  boost' = boost186.override {
    enableShared = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "autodock-vina";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "ccsb-scripps";
    repo = "autodock-vina";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQJl/EUAkdIQJZSN27sbjG7dYbQxeEb8Pd+p2kKRnvA=";
  };

  sourceRoot = "${finalAttrs.src.name}/build/${
    if stdenv.hostPlatform.isDarwin then "mac" else "linux"
  }/release";

  buildInputs = [
    boost'
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glibc.static
  ];

  makeFlags = [
    "GPP=${stdenv.cc.targetPrefix}c++"
    "BASE=${boost'}"
    "BOOST_INCLUDE=${lib.getDev boost'}/include"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 vina vina_split -t $out/bin/

    runHook postInstall
  '';

  passthru.boost = boost';

  meta = with lib; {
    description = "One of the fastest and most widely used open-source docking engines";
    homepage = "https://vina.scripps.edu/";
    changelog = "https://github.com/ccsb-scripps/AutoDock-Vina/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
    mainProgram = "vina";
  };
})
