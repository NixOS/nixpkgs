{ lib
, stdenv
, fetchFromGitHub
, jdk
, jre
, survex
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tunnelx";
  version = "2023-07-nix";

  src = fetchFromGitHub {
    owner = "CaveSurveying";
    repo = "tunnelx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H6lHqc9on/pv/KihNcaHPwbWf4JXRkeRqNoYq6yVKqM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    jdk
  ];

  runtimeInputs = [
    survex
  ];

  buildPhase = ''
    javac -d . src/*.java
  '';

  installPhase = ''
    mkdir -p $out/bin $out/java
    cp -r symbols Tunnel tutorials $out/java
    makeWrapper ${jre}/bin/java $out/bin/tunnelx \
      --add-flags "-cp $out/java Tunnel.MainBox" \
      --set SURVEX_EXECUTABLE_DIR ${survex}/bin/ \
      --set TUNNEL_USER_DIR $out/java/
  '';

  meta = with lib; {
    description = "A program for drawing cave surveys in 2D";
    homepage = "https://github.com/CaveSurveying/tunnelx/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goatchurchprime ];
  };
})
