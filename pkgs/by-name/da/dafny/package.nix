{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  runCommand,
  dafny,
  writeScript,
  jdk11,
  z3,
  dotnetCorePackages,
}:

let
  examples = fetchFromGitHub {
    owner = "gaberch";
    repo = "Various-Algorithms-Verified-With-Dafny";
    rev = "50e451bbcd15e52e27d5bbbf66b0b4c4abbff41c";
    hash = "sha256-Ng5wve/4gQr/2hsFWUFFcTL3K2xH7dP9w8IrmvWMKyg=";
  };

  tests = {
    verify = runCommand "dafny-test" { } ''
      mkdir $out
      cp ${examples}/SlowMax.dfy $out
      ${dafny}/bin/dafny verify --allow-warnings $out/SlowMax.dfy
    '';

    # Broken, cannot compile generated .cs files for now
    #run = runCommand "dafny-test" { } ''
    #    mkdir $out
    #    cp ${examples}/SlowMax.dfy $out
    #    ${dafny}/bin/dafny run --allow-warnings $out/SlowMax.dfy
    #  '';

    # TODO: Ensure then tests that dafny can generate to and compile other
    # languages (Java, Cpp, etc.)
  };
in
buildDotnetModule rec {
  pname = "Dafny";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "dafny-lang";
    repo = "dafny";
    tag = "v${version}";
    hash = "sha256-aPOjt4bwalhJUTJm4+pGqN88LwDP5zrVtakF26b3K4s=";
  };

  postPatch =
    let
      runtimeJarVersion = "4.10.0";
    in
    ''
      cp ${writeScript "fake-gradlew-for-dafny" ''
        mkdir -p build/libs/
        javac $(find -name "*.java" | grep "^./src/main") -d classes
        jar cf build/libs/DafnyRuntime-${runtimeJarVersion}.jar -C classes dafny
      ''} Source/DafnyRuntime/DafnyRuntimeJava/gradlew

      # Needed to fix
      # "error NETSDK1129: The 'Publish' target is not supported without
      # specifying a target framework. The current project targets multiple
      # frameworks, you must specify the framework for the published
      # application."
      substituteInPlace Source/DafnyRuntime/DafnyRuntime.csproj \
        --replace-fail TargetFrameworks TargetFramework \
        --replace-fail "netstandard2.0;net452" net8.0
    '';

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nativeBuildInputs = [ jdk11 ];
  nugetDeps = ./deps.json;

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

  passthru.tests = tests;

  meta = with lib; {
    description = "Programming language with built-in specification constructs";
    homepage = "https://research.microsoft.com/dafny";
    maintainers = with maintainers; [ layus ];
    license = licenses.mit;
    platforms = with platforms; (linux ++ darwin);
  };
}
