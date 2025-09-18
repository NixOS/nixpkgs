{
  lib,
  stdenv,
  fetchurl,
  jdk8,
  jre8,
  makeBinaryWrapper,
  runCommand,
  python3Packages,
  writeText,
}:
let
  jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticmq-server";
  version = "1.6.14";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-${finalAttrs.version}.jar";
    sha256 = "sha256-HVllLHz6zutonaLFwgyQKYSZxfp5QMslxf/PlzGWyG4=";
  };

  # don't do anything?
  unpackPhase = "${jdk}/bin/jar xf $src favicon.png";

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/elasticmq-server

    cp $src $out/share/elasticmq-server/elasticmq-server.jar

    # TODO: how to add extraArgs? current workaround is to use JAVA_TOOL_OPTIONS environment to specify properties
    makeWrapper ${jre}/bin/java $out/bin/elasticmq-server \
      --add-flags "-jar $out/share/elasticmq-server/elasticmq-server.jar"
  '';

  passthru.tests.elasticmqTest = import ./elasticmq-test.nix {
    inherit runCommand python3Packages writeText;
    elasticmq-server = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    homepage = "https://github.com/softwaremill/elasticmq";
    changelog = "https://github.com/softwaremill/elasticmq/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterromfeldhk ];
    mainProgram = "elasticmq-server";
  };
})
