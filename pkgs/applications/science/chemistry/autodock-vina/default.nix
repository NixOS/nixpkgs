{ lib
, stdenv
, fetchFromGitHub
, boost
, glibc
}:
let
  boost' = boost.override {
    enableShared = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "autodock-vina";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "ccsb-scripps";
    repo = "autodock-vina";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-oOpwhRmpS5WfnuqxkjxGsGtrofPxUt8bH9ggzm5rrR8=";
  };

  sourceRoot =
    if stdenv.isDarwin
    then "source/build/mac/release"
    else "source/build/linux/release";

  buildInputs = [
    boost'
  ] ++ lib.optionals stdenv.isLinux [
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
