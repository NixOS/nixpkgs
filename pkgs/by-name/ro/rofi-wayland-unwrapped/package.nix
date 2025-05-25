{
  fetchFromGitHub,
  rofi-unwrapped,
  wayland-scanner,
  pkg-config,
  wayland-protocols,
  wayland,
}:

rofi-unwrapped.overrideAttrs (
  final: prev: {
    pname = "rofi-wayland-unwrapped";
    version = "1.7.8+wayland1";

    src = fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      tag = final.version;
      fetchSubmodules = true;
      hash = "sha256-6hQfy0c73z1Oi2mGjuhKLZQIBpG1u06v40dmlc5fL/w=";
    };

    depsBuildBuild = prev.depsBuildBuild ++ [
      pkg-config
    ];
    nativeBuildInputs = prev.nativeBuildInputs ++ [
      wayland-protocols
      wayland-scanner
    ];
    buildInputs = prev.buildInputs ++ [
      wayland
      wayland-protocols
    ];
  }
)
