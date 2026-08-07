{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  libx11,
  libxrandr,
  libxi,
  libxcursor,
  libxinerama,
  libGL,
  mesa,
  libxxf86vm,
  libglvnd,
  makeWrapper,
}:

buildGo126Module rec {
  pname = "guac";
  version = "0.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aabalke";
    repo = "guac";
    rev = "v${version}";
    hash = "sha256-iHqeeo4MXYDjtJQ667gOYTZX8RbZ4HZspNt4so0ps8c=";
  };

  vendorHash = "sha256-tJYuEzk0yyEycFOneig9E3HI7xBT2EVy97itssSx5Lk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libGL
    libx11
    libxrandr
    libxi
    libxcursor
    libxinerama
    mesa
    libxxf86vm
    libglvnd
  ];

  buildPhase = ''
    runHook preBuild
    go build -o guac .
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv guac $out/bin/guac
    wrapProgram $out/bin/guac --set LD_LIBRARY_PATH "${mesa}/lib:${libglvnd}/lib:${libGL}/lib"
  '';

  meta = {
    description = "NDS, GBA, GBC, DMG Emulator written in golang";
    homepage = "https://github.com/aabalke/guac";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "guac";
  };
}
