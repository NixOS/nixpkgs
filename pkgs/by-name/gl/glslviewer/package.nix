{
  stdenv,
  cmake,
  ninja,
  lib,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  ncurses,
  glfw,
  Cocoa,
}:
stdenv.mkDerivation rec {
  pname = "glslviewer";
  version = "3.2.4";
  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-Ve3wmX5+kABCu8IRe4ySrwsBJm47g1zvMqDbqrpQl88=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    ncurses
    ffmpeg
    glfw
  ] ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;

  # This CMakeLists builds a version of glfw that does not work in wayland
  patchPhase = ''
    echo "" > ./deps/vera/deps/CMakeLists.txt
  '';

  # These scripts are a bit hacky and depend on X11 tools
  postInstall = ''
    rm $out/bin/glslScreenSaver
    rm $out/bin/glslThumbnailer
  '';

  meta = with lib; {
    description = "Live GLSL coding renderer";
    homepage = "https://patriciogonzalezvivo.com/2015/glslViewer/";
    license = licenses.bsd3;
    maintainers = [
      maintainers.hodapp
      maintainers.leiserfg
    ];
    platforms = platforms.unix;
    mainProgram = "glslViewer";
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
