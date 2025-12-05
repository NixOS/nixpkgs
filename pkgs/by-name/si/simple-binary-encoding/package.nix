{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jre,
  runtimeShell,

  # Generating the usage instructions for script
  htmlq,
  html2text,
  txt2man,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "simple-binary-encoding";
  version = "1.36.2";

  src = fetchFromGitHub {
    owner = "aeron-io";
    repo = "simple-binary-encoding";
    tag = finalAttrs.version;
    hash = "sha256-GQNJI/QZh7EZk06OhDoh4znnEBC4d5pnrQyhHL+HbzA=";
  };

  nativeBuildInputs = [
    gradle
    htmlq
    html2text
    txt2man
  ];

  mitmCache = gradle.fetchDeps {
    pname = "simple-binary-encoding";
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  gradleBuildTask = "build";

  doCheck = true;
  gradleCheckTask = "runJavaExamples";

  outputs = [
    "out"
    "benchmarks"
    "samples"
    "tool"
  ];

  installPhase = ''
    runHook preInstall

    for output in $outputs; do
      if [[ "$output" != "out" ]]; then
        mkdir -p "''${!output}"/share/sbe
        cp "sbe-$output"/build/libs/*.jar "''${!output}/share/sbe"
        if [[ -d "sbe-$output"/build/docs/javadoc ]]; then
          cp -r "sbe-$output"/build/docs/javadoc "''${!output}/share/javadoc"
        fi
      fi
      if [[ "$output" == "tool" ]]; then
        cp sbe-all/build/libs/*.jar "$tool/share/sbe"
      fi
    done

    mkdir -p "$out/"{bin,share/doc,share/man}

    # Generate the usage file from the javadoc
    shopt -s globstar
    cat "$tool/share/javadoc"/**/sbe/SbeTool.html \
      | htmlq '.class-description .block' \
      | html2text \
      | sed -e 's/[$] java/$ sbetool/' -e 's/ -jar sbe.jar//' -e 's/System Properties:/Available Options:/' \
      > "$out/share/doc/sbetool.txt"

    echo >> "$out/share/doc/sbetool.txt"
    echo "All other arguments will be interpreted by java(1)." >> "$out/share/doc/sbetool.txt"

    # Generate a manpage
    sed \
      -e '1i\NAME\nsbetool - ' \
      -e 's/Usage:/\nSYNOPSIS\n/' \
      -e 's/Available Options:/\nOPTIONS\n/' \
      < "$out/share/doc/sbetool.txt" \
      | txt2man \
        -P simple-binary-encoding \
        -t "sbetool" -s1 \
        -r "$pname $verison" \
        -v "Simple Binary Encoding" \
        > "$out/share/man/sbetool.1"

    runtimeShell="${runtimeShell}" java="${lib.getExe jre}" \
      substituteAll ${./sbetool.sh} "$out/bin/sbetool"

    chmod +x "$out/bin/sbetool"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Check that we have some usage documentation
    "$out"/bin/sbetool --help 2>&1 | grep -q Usage

    # Check that the script can pass arguments to the underlying jar
    tmpdir="$(mktemp -d)"
    "$out"/bin/sbetool \
      sbe-tool/src/test/resources/example-schema.xml \
      -Dsbe.target.language=golang \
      -Dsbe.output.dir="$tmpdir"
    find "$tmpdir/baseline" | grep -q '.*[.]go'

    # Check that -- passes as files
    tmpdir="$(mktemp -d)"
    cp sbe-tool/src/test/resources/example-schema.xml -- -e.xml
    "$out"/bin/sbetool \
      -Dsbe.target.language=golang \
      -Dsbe.output.dir="$tmpdir" \
      -- \
      -e.xml
    find "$tmpdir/baseline" | grep -q '.*[.]go'
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/aeron-io/simple-binary-encoding";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ balsoft ];
    description = "OSI layer 6 presentation for encoding and decoding binary application messages for low-latency financial applications";
  };
})
