{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:
stdenv.mkDerivation rec {
  pname = "hyprland-protocols";
  version = "unstable-2023-01-13";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "eb7dcc0132ad25addc3e8d434c4bfae6bd3a8c90";
    hash = "sha256-gkLgUg9/fP04bKCJMj/rN0r6PV/cbLShDvKQyFvVap0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
}
