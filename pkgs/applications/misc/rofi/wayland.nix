{ stdenv
, lib
, fetchFromGitHub
, rofi-unwrapped
, wayland-protocols
, wayland
}:

rofi-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "rofi-wayland-unwrapped";
  version = "1.7.2+wayland1";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-INFYHOVjBNj8ks4UjKnxLW8mL7h1c8ySFPS/rUxOWwo=";
  };

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wayland-protocols ];
  buildInputs = oldAttrs.buildInputs ++ [ wayland ];

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement for Wayland";
    homepage = "https://github.com/lbonn/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
})
