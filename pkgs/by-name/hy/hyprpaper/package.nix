{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  hyprwayland-scanner,
  hyprwire,
  pkg-config,
  wayland-scanner,
  expat,
  file,
  fribidi,
  hyprlang,
  hyprtoolkit,
  libdatrie,
  libjpeg,
  libjxl,
  libselinux,
  libsepol,
  libthai,
  libwebp,
  libxdmcp,
  pcre2,
  wayland-protocols,
  util-linux,
  versionCheckHook,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lvfZGHZYGof4SoPjFs1Cv6xy/Km9/UyDeZn6mmedbzI=";
  };

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.tag}"'
  '';

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    hyprwire
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    expat
    file
    fribidi
    hyprlang
    hyprtoolkit
    libdatrie
    libjpeg
    libjxl
    libselinux
    libsepol
    libthai
    libwebp
    libxdmcp
    pcre2
    wayland-protocols
    util-linux
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Blazing fast wayland wallpaper utility";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (hyprtoolkit.meta) platforms;
    broken = gcc16Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprpaper";
  };
})
