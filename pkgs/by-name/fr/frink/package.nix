{
  fetchurl,
  frink,
  jdk,
  lib,
  rlwrap,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "frink";
  version = "2025-01-07";

  src = fetchurl {
    # Upstream does not provide versioned download links
    url = "https://web.archive.org/web/20250119105218/https://frinklang.org/frinkjar/frink-tng.jar";
    sha256 = "sha256-qsbYUUBBVILUG6oZVR3t5UaVdNew6xRvjqQBJVr76L8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jdk ];

  buildInputs = [
    jdk
    rlwrap
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    cp ${src} $out/lib/frink-tng.jar

    # Generate rlwrap helper files.
    # See https://frinklang.org/fsp/colorize.fsp?f=listUnits.frink
    # and https://frinklang.org/fsp/colorize.fsp?f=listFunctions.frink
    java -classpath "$out/lib/frink-tng.jar" frink.gui.FrinkStarter -e 'joinln[lexicalSort[units[]]]' > $out/lib/unitnames.txt
    java -classpath "$out/lib/frink-tng.jar" frink.gui.FrinkStarter -e 'joinln[map[{|f|
        f =~ %s/\s+//g
        return "$f$"
      }, lexicalSort[functions[]]]]' > $out/lib/functionnames.txt

    cat > "$out/bin/frink" << EOF
    #!${stdenv.shell}
    exec ${rlwrap}/bin/rlwrap -f $out/lib/unitnames.txt -b '$' -f $out/lib/functionnames.txt ${jdk}/bin/java -classpath "$out/lib/frink-tng.jar" frink.gui.FrinkStarter "\$@"
    EOF

    chmod a+x "$out/bin/frink"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Practical calculating tool and programming language";
    homepage = "https://frinklang.org/";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    maintainers = [ maintainers.stefanfehrenbach ];
  };

  passthru.tests = {
    callFrinkVersion = testers.testVersion {
      package = frink;
      command = "frink -e 'FrinkVersion[]'";
    };
  };
}
