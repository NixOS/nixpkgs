{ lib
, stdenv
, fetchzip
, jq
, openjdk11
}:

stdenv.mkDerivation rec {
  pname = "eclair";
  version = "0.7.0-patch-disconnect";
  revision = "cad88bf";

  src = fetchzip {
    url = "https://github.com/ACINQ/eclair/releases/download/v${version}/eclair-node-${version}-${revision}-bin.zip";
    hash = "sha256-agOxflCXfoeSeGliB/PAMMyCdqYYajciHMfLrSiZx1Q=";
  };

  propagatedBuildInputs = [ jq openjdk11 ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -a * $out
    mv $out/bin/eclair-node.sh $out/bin/eclair-node
    rm $out/bin/eclair-node.bat

    runHook postInstall
  '';

  meta = with lib; {
    description = "A scala implementation of the Lightning Network";
    homepage = "https://github.com/ACINQ/eclair";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}
