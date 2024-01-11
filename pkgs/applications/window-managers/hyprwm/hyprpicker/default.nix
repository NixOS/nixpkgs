{
  lib,
  stdenv,
  pkg-config,
  cmake,
  ninja,
  cairo,
  fribidi,
  libdatrie,
  libGL,
  libjpeg,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  pango,
  pcre,
  utillinux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  libXdmcp,
  debug ? false,
  version ? "git",
}:
stdenv.mkDerivation {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
  inherit version;
  src = ../.;

  cmakeFlags = lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
    fribidi
    libdatrie
    libGL
    libjpeg
    libselinux
    libsepol
    libthai
    pango
    pcre
    wayland
    wayland-protocols
    wayland-scanner
    wlroots
    libXdmcp
    libxkbcommon
    utillinux
  ];

  configurePhase = ''
    runHook preConfigure

    make protocols

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/licenses}

    install -Dm755 build/hyprpicker -t $out/bin
    install -Dm644 LICENSE -t $out/share/licenses/hyprpicker

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprpicker";
    description = "A wlroots-compatible Wayland color picker that does not suck";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
