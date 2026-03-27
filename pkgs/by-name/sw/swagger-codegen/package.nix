{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  version = "2.4.50";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/io/swagger/${pname}-cli/${version}/${jarfilename}";
    sha256 = "sha256-rsoQFd5XTIcAz32jv2vv/OkqSSC3wCvxBeRbVJhZfLA=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jraygauthier ];
    mainProgram = "swagger-codegen";
  };
}
