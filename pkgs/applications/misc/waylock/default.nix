{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, libxkbcommon
, pam
, pkg-config
, scdoc
, wayland
, wayland-protocols
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
=======
, zig
, wayland
, pkg-config
, scdoc
, wayland-protocols
, libxkbcommon
, pam
}:
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "waylock";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ifreund";
<<<<<<< HEAD
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jl4jSDWvJB6OfBbVXfVQ7gv/aDkN6bBy+/yK+AQDQL0=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland
    zig_0_10.hook
  ];
=======
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jl4jSDWvJB6OfBbVXfVQ7gv/aDkN6bBy+/yK+AQDQL0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig wayland scdoc pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    wayland-protocols
    libxkbcommon
    pam
  ];

<<<<<<< HEAD
  zigBuildFlags = [ "-Dman-pages" ];

  meta = {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jordanisaacs ];
    mainProgram = "waylock";
    platforms = lib.platforms.linux;
  };
})
=======
  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dman-pages -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
