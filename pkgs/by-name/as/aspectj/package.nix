{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
}:

let
  version = "1.9.22.1";
  versionSnakeCase = builtins.replaceStrings [ "." ] [ "_" ] version;
in
stdenvNoCC.mkDerivation {
  pname = "aspectj";
  inherit version;

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/eclipse/org.aspectj/releases/download/V${versionSnakeCase}/aspectj-${version}.jar";
    hash = "sha256-NIyYVhJIGXz+vNVoAQzYsDfmOYc4QrRzJGWeQjS4X0U=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    cat >> props <<EOF
    output.dir=$out
    context.javaPath=${jre}
    EOF

    mkdir -p $out
    java -jar $src -text props

    cat >> $out/bin/aj-runtime-env <<EOF
    #! ${stdenvNoCC.shell}

    export CLASSPATH=$CLASSPATH:.:$out/lib/aspectjrt.jar
    EOF

    chmod u+x $out/bin/aj-runtime-env

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.eclipse.org/aspectj/";
    description = "Seamless aspect-oriented extension to the Java programming language";
    license = licenses.epl10;
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
