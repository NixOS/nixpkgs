{ lib
, stdenv
, fetchzip
, jq
, openjdk11
}:

stdenv.mkDerivation rec {
  pname = "eclair";
  version = "0.6.1";
  revision = "d3ae323";

  src = fetchzip {
    url = "https://github.com/ACINQ/eclair/releases/download/v${version}/eclair-node-${version}-${revision}-bin.zip";
    sha256 = "0hmdssj6pxhvadrgr1svb2lh7hfbd2axr5wsl7glizv1a21g0l2c";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
