{
  stdenv,
  cmake,
  ninja,
  lib,
  fetchFromGitHub,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libGLU,
  ffmpeg_7,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "glslviewer";
  version = "3.2.4";
  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    fetchSubmodules = true;
    tag = version;
    hash = "sha256-Ve3wmX5+kABCu8IRe4ySrwsBJm47g1zvMqDbqrpQl88=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libGLU
    ncurses
    ffmpeg_7
  ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.20" ];

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/glslViewer.thumbnailer \
      --replace-fail "TryExec=glslThumbnailer" "TryExec=$out/bin/glslThumbnailer" \
      --replace-fail "Exec=glslThumbnailer" "Exec=$out/bin/glslThumbnailer"
  '';

  meta = {
    description = "Live GLSL coding renderer";
    homepage = "https://patriciogonzalezvivo.com/2015/glslViewer/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.hodapp ];
    platforms = lib.platforms.unix;
    mainProgram = "glslViewer";
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
