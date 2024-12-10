{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  glibc,
}:
let
  boost' = boost.override {
    enableShared = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "autodock-vina";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "ccsb-scripps";
    repo = "autodock-vina";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-yguUMEX0tn75wKrPKyqlCYbBFaEwC5b1s3k9xept1Fw=";
  };

  sourceRoot = "${finalAttrs.src.name}/build/${
    if stdenv.hostPlatform.isDarwin then "mac" else "linux"
  }/release";

  buildInputs =
    [
      boost'
    ]
    ++ lib.optionals stdenv.isLinux [
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
