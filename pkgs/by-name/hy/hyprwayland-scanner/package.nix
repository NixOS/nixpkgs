{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pugixml
,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwayland-scanner";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwayland-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BPc9FdIzQAmP1JnYGfr+3O30Yp1BywUvKUz57ZOZ39A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pugixml
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprwayland-scanner";
    description = "A Hyprland version of wayland-scanner in and for C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fufexan ];
    mainProgram = "hyprwayland-scanner";
    platforms = platforms.linux;
  };
})
