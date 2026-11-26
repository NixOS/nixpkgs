{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  gradle,
  openjdk,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastddsgen";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-BCih45l6t3DlmNnWNIhCe6ou8cWpVlgkGh4nUmGXq4w=";
  };

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

  meta = {
    description = "Fast-DDS IDL code generator tool";
    mainProgram = "fastddsgen";
    homepage = "https://github.com/eProsima/Fast-DDS-Gen";
    license = lib.licenses.asl20;
    longDescription = ''
      eProsima Fast DDS-Gen is a Java application that generates
      eProsima Fast DDS C++ or Python source code using the data types
      defined in an IDL (Interface Definition Language) file. This
      generated source code can be used in any Fast DDS application in
      order to define the data type of a topic, which will later be
      used to publish or subscribe.
    '';
    maintainers = with lib.maintainers; [ wentasah ];
    platforms = openjdk.meta.platforms;
  };
})
