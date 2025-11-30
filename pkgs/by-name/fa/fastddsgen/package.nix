{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  fetchpatch2,
  gradle,
  openjdk,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastddsgen";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-weGS340MvPitWMgWx1cWTgYgGcQfJSTUus8EcBob7hY=";
  };

  patches = [
    # Note: PR is not yet merged
    # Select commit from https://github.com/eProsima/IDL-Parser/pull/179
    (fetchpatch2 {
      url = "https://github.com/eProsima/IDL-Parser/commit/801ed2f671322c0134b8db180529c9a400d5ed2b.patch";
      stripLen = 1;
      extraPrefix = "thirdparty/idl-parser/";
      includes = [ "thirdparty/idl-parser/build.gradle" ];
      hash = "sha256-OzywQ02yaMnya+536DeHWeKwZefI4meYqmZcp3onwR8=";
    })

    # Note: PR is not yet merged
    # Select commit from https://github.com/eProsima/Fast-DDS-Gen/pull/493
    (fetchpatch2 {
      url = "https://github.com/eProsima/Fast-DDS-Gen/commit/b1b66d587f38d4fd6227aa1969c3a10c2095ae7d.patch";
      hash = "sha256-qVp9Xk8og8Ga2BMiqt2BFM0lAtDnmmwzteceievfcXE=";
    })

    ./493-addendum.patch
  ];

  nativeBuildInputs = [
    gradle
    openjdk
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-x"
    "submodulesUpdate"
  ];

  installPhase = ''
    runHook preInstall

    gradle install --install_path=$out

    # Override the default start script to use absolute java path.
    # Make the unwrapped "cpp" available in the path, since the wrapped "cpp"
    # passes additional flags and produces output incompatible with fastddsgen.
    makeWrapper ${openjdk}/bin/java $out/bin/fastddsgen \
      --add-flags "-jar $out/share/fastddsgen/java/fastddsgen.jar" \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc ]}

    runHook postInstall
  '';

  postGradleUpdate = ''
    cd thirdparty/idl-parser
    # fix "Task 'submodulesUpdate' not found"
    gradleFlags=
    gradle nixDownloadDeps
  '';

  passthru.tests = testers.testVersion {
    command = "${finalAttrs.meta.mainProgram} -version";
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Fast-DDS IDL code generator tool";
    mainProgram = "fastddsgen";
    homepage = "https://github.com/eProsima/Fast-DDS-Gen";
    license = licenses.asl20;
    longDescription = ''
      eProsima Fast DDS-Gen is a Java application that generates
      eProsima Fast DDS C++ or Python source code using the data types
      defined in an IDL (Interface Definition Language) file. This
      generated source code can be used in any Fast DDS application in
      order to define the data type of a topic, which will later be
      used to publish or subscribe.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = openjdk.meta.platforms;
  };
})
