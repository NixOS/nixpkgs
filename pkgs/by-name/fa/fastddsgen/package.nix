{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  gradle_7,
  openjdk17,
}:

let
  pname = "fastddsgen";
  version = "4.0.2";

  gradle = gradle_7;

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-dwShzcS0sCiVZghpjvPYvYu89NNkGWUWPsAzwdzfAqo=";
  };

  nativeBuildInputs = [
    gradle
    openjdk17
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
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
    makeWrapper ${openjdk17}/bin/java $out/bin/fastddsgen \
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
    platforms = openjdk17.meta.platforms;
  };
}
