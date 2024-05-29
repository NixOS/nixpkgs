{ lib
, buildDotnetModule
, fetchFromGitHub
, runCommand
, dafny
, writeScript
, jdk11
, z3
}:

let
  test = runCommand "dafny-test"
    {
      src = fetchFromGitHub {
        owner = "gaberch";
        repo = "Various-Algorithms-Verified-With-Dafny";
        rev = "50e451bbcd15e52e27d5bbbf66b0b4c4abbff41c";
        hash = "sha256-Ng5wve/4gQr/2hsFWUFFcTL3K2xH7dP9w8IrmvWMKyg=";
      };
    }
    ''
      mkdir $out
      cp $src/SlowMax.dfy $out
      ${dafny}/bin/dafny $out/SlowMax.dfy
    '';
in
buildDotnetModule rec {
  pname = "Dafny";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "dafny-lang";
    repo = "dafny";
    rev = "v${version}";
    hash = "sha256-3t0drxM7PZzrLbxBKYa6Gja2u6GK6Pc+ejoswag3P3k=";
  };

  postPatch = ''
    cp ${
      writeScript "fake-gradlew-for-dafny" ''
        mkdir -p build/libs/
        javac $(find -name "*.java" | grep "^./src/main") -d classes
        jar cf build/libs/DafnyRuntime-${version}.jar -C classes dafny
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

  passthru.tests = { inherit test; };

  meta = with lib; {
    description = "A programming language with built-in specification constructs";
    homepage = "https://research.microsoft.com/dafny";
    maintainers = with maintainers; [ layus ];
    license = licenses.mit;
    platforms = with platforms; (linux ++ darwin);
  };
}
