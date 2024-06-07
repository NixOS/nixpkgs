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
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwayland-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hRE0+vPXQYB37nx07HQMnaCV5wJjShOeqRygw3Ga6WM=";
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
