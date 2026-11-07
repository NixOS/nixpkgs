{
  jdk8,
  ant,
  makeWrapper,
  stdenv,
  fetchFromGitLab,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "openrsc-launcher";
  version = "5.29.0";
  src = fetchFromGitLab {
    owner = "openrsc";
    repo = "openrsc";
    tag = "ORSC-${version}";
    hash = "sha256-e2VXV0xk0Xx2zQNtg20/PwJmwqHvbZlSUZc0wlPO0vA=";
  };

  buildInputs = [
    jdk8
  ];

  nativeBuildInputs = [
    ant
    makeWrapper
  ];

  buildPhase = ''
    cd ./PC_Launcher && ant
    mkdir -p $out/share/pixmaps $out/share/applications
    cp vet.rsc.OpenRSC.Launcher.svg $out/share/pixmaps
    cp vet.rsc.OpenRSC.Launcher.desktop $out/share/applications
    cp OpenRSC.jar $out/share
    makeWrapper ${jdk8}/bin/java $out/bin/openrsc \
      --prefix PATH : ${jdk8}/bin \
      --add-flags "-jar $out/share/OpenRSC.jar --dir ~/.local/share/openrsc --no-update"
  '';

  JAVA_TOOL_OPTIONS = "-Dfile.encoding=UTF8";

  meta = {
    description = "Free, open-source launcher for various Classic (2001-2004) RSC servers";
    homepage = "https://rsc.vet/";
    license = lib.licenses.agpl3Only;
    platforms = jdk8.meta.platforms;
    mainProgram = "openrsc";
  };
}
