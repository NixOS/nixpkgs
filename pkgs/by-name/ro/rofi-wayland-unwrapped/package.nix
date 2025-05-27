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
    version = "1.7.9+wayland1";

    src = fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      tag = final.version;
      fetchSubmodules = true;
      hash = "sha256-tLSU0Q221Pg3JYCT+w9ZT4ZbbB5+s8FwsZa/ehfn00s=";
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
