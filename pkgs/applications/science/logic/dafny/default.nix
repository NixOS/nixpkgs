{ lib
, buildDotnetModule
, fetchFromGitHub
, writeScript
, jdk11
, z3
}:

buildDotnetModule rec {
  pname = "Dafny";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "dafny-lang";
    repo = "dafny";
    rev = "v${version}";
    hash = "sha256-bnKaaqh1/921SRwnwqgYb31SJ8vguEBtzywPTz79S6I=";
  };

  postPatch =
    # This version number seems to be hardcoded and didn't get updated with the
    # version bump from 4.2.0 to 4.3.0.
    let dafnyRuntimeJarVersion = "4.2.0";
    in ''
      cp ${
        writeScript "fake-gradlew-for-dafny" ''
          mkdir -p build/libs/
          javac $(find -name "*.java" | grep "^./src/main") -d classes
          jar cf build/libs/DafnyRuntime-${dafnyRuntimeJarVersion}.jar -C classes dafny
        ''} Source/DafnyRuntime/DafnyRuntimeJava/gradlew

      # Needed to fix
      # "error NETSDK1129: The 'Publish' target is not supported without
      # specifying a target framework. The current project targets multiple
      # frameworks, you must specify the framework for the published
      # application."
      substituteInPlace Source/DafnyRuntime/DafnyRuntime.csproj \
        --replace TargetFrameworks TargetFramework \
        --replace "netstandard2.0;net452" net6.0
    '';

  buildInputs = [ jdk11 ];
  nugetDeps = ./deps.nix;

  # Build just these projects. Building Source/Dafny.sln includes a bunch of
  # unnecessary components like tests.
  projectFile = [
    "Source/Dafny/Dafny.csproj"
    "Source/DafnyRuntime/DafnyRuntime.csproj"
    "Source/DafnyLanguageServer/DafnyLanguageServer.csproj"
  ];

  executables = [ "Dafny" ];

  # Help Dafny find z3
  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ z3 ]}" ];

  postFixup = ''
    ln -s "$out/bin/Dafny" "$out/bin/dafny" || true
  '';

  meta = with lib; {
    description = "A programming language with built-in specification constructs";
    homepage = "https://research.microsoft.com/dafny";
    maintainers = with maintainers; [ layus ];
    license = licenses.mit;
    platforms = with platforms; (linux ++ darwin);
  };
}
