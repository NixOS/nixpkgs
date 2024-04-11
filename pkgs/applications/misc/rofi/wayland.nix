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
  version = "1.7.5+wayland3";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-pKxraG3fhBh53m+bLPzCigRr6dBcH/A9vbdf67CO2d8=";
  };

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wayland-scanner ];
  buildInputs = oldAttrs.buildInputs ++ [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement for Wayland";
    homepage = "https://github.com/lbonn/rofi";
    license = licenses.mit;
    mainProgram = "rofi";
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
})
