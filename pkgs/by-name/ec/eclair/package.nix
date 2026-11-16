{
  lib,
  stdenv,
  fetchzip,
  jq,
  openjdk21,
}:

stdenv.mkDerivation rec {
  pname = "eclair";
  version = "0.14.2";
  revision = "3dd8d2d";

  src = fetchzip {
    url = "https://github.com/ACINQ/eclair/releases/download/v${version}/eclair-node-${version}-${revision}-bin.zip";
    hash = "sha256-4S2xAEGc1/9cs2n/fE4weIB7+oCqzH500QyTOaZew7A=";
  };

  propagatedBuildInputs = [
    jq
    openjdk21
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -a * $out
    mv $out/bin/eclair-node.sh $out/bin/eclair-node
    rm $out/bin/eclair-node.bat

    runHook postInstall
  '';

  meta = {
    description = "Scala implementation of the Lightning Network";
    homepage = "https://github.com/ACINQ/eclair";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.unix;
  };
}
