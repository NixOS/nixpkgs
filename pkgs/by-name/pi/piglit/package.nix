{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
  glslang,
  libffi,
  libgbm,
  libglut,
  libGL,
  libGLU,
  libglvnd,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  vulkan-loader,
  waffle,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libXau,
  libX11,
  libXrender,
  libxcb,
  libxkbcommon,
  mesa,
}:

stdenv.mkDerivation {
  pname = "piglit";
  version = "unstable-2025-04-15";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "piglit";
    rev = "d06f7bac988e67db53cbc05dc0b096b00856ab93";
    hash = "sha256-bH9NjLEldlZwylq7S0q2vC5IQhUej0xZ6wD+mrWBK5A=";
  };

  buildInputs = [
    glslang
    libffi
    libgbm
    libglut
    libGL
    libGLU
    libglvnd
    libXau
    libX11
    libXrender
    libxcb
    libxkbcommon
    (python3.withPackages (
      ps: with ps; [
        mako
        numpy
      ]
    ))
    vulkan-loader
    waffle
    wayland
    wayland-protocols
    wayland-scanner
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
  ];

  # Find data dir: piglit searches for the data directory in some places, however as it is wrapped,
  # it search in ../lib/.piglit-wrapped, we just replace the script name with "piglit" again.
  prePatch = ''
    substituteInPlace piglit \
      --replace 'script_basename_noext = os.path.splitext(os.path.basename(__file__))[0]' 'script_basename_noext = "piglit"'
  '';

  postInstall = ''
    wrapProgram $out/bin/piglit \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libglvnd
        ]
      } \
      --prefix PATH : "${waffle}/bin"
  '';

  meta = with lib; {
    description = "OpenGL test suite, and test-suite runner";
    homepage = "https://gitlab.freedesktop.org/mesa/piglit";
    license = licenses.free; # custom license. See COPYING in the source repo.
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [ Flakebi ];
    mainProgram = "piglit";
  };
}
