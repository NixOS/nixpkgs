{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, ninja
, cairo
, fribidi
, libdatrie
, libjpeg
, libselinux
, libsepol
, libthai
, pango
, pcre
, util-linux
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, libXdmcp
, debug ? false
}:
stdenv.mkDerivation {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
  version = "unstable-2023-03-31";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    rev = "cc6b3234b2966acd61c8a2e5caae947774666601";
    hash = "sha256-8Tc8am5+iQvzRdnTYIpD3Ewge6TIctrm8tr0H+RvcsE=";
  };

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
    util-linux
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
    description = "A wlroots-compatible Wayland color picker that does not suck";
    homepage = "https://github.com/hyprwm/hyprpicker";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    platforms = wayland.meta.platforms;
  };
}
