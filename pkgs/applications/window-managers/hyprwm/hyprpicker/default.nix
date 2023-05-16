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
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpicker" + lib.optionalString debug "-debug";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-k+rG5AZjz47Q6bpVcTK7r4s7Avg3O+1iw+skK+cn0rk=";
=======
    hash = "sha256-8Tc8am5+iQvzRdnTYIpD3Ewge6TIctrm8tr0H+RvcsE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
})
