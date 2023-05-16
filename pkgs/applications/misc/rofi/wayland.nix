{ stdenv
, lib
, fetchFromGitHub
, rofi-unwrapped
, wayland-scanner
, wayland-protocols
, wayland
}:

rofi-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "rofi-wayland-unwrapped";
<<<<<<< HEAD
  version = "1.7.5+wayland2";
=======
  version = "1.7.5+wayland1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-5pxDA/71PV4B5T3fzLKVC4U8Gt13vwy3xSDPDsSDAKU=";
=======
    sha256 = "sha256-ddKLV7NvqgTQl5YlAEyBK0oalcJsLASK4z3qArQPUDQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wayland-scanner ];
  buildInputs = oldAttrs.buildInputs ++ [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement for Wayland";
    homepage = "https://github.com/lbonn/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
})
