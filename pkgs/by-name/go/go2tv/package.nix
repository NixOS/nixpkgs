{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libxcursor,
  libx11,
  libglvnd,
  libxkbcommon,
  pipewire,
  pkg-config,
  wayland,
  withGui ? true,
}:

buildGoModule rec {
  pname = "go2tv" + lib.optionalString (!withGui) "-lite";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "alexballas";
    repo = "go2tv";
    tag = "v${version}";
    hash = "sha256-T+j7Bw22+mooZSF8U6VYc/DB6MAzEQoNotVXHdFa8XQ=";
  };

  vendorHash = "sha256-RXBQdUgSFYvQ7Sb8iKv4bS4eXCo/Dn1f2JEs0QGTFbo=";

  nativeBuildInputs = [ pkg-config ];

  env = {
    # allow flag from `pkg-config --cflags libpipewire-0.3`
    CGO_CFLAGS_ALLOW = "-fno-strict-overflow";
  };

  buildInputs = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
    libxext
    libxxf86vm
    libglvnd
    libxkbcommon
    pipewire
    wayland
  ];

  ldflags = [
    "-s"
    "-w"
    "-linkmode=external"
  ];

  # conditionally build with GUI or not (go2tv or go2tv-lite sub-packages)
  subPackages = [ "cmd/${pname}" ];

  doCheck = false;

  meta = {
    description = "Cast media files to UPnP/DLNA Media Renderers and Smart TVs";
    homepage = "https://github.com/alexballas/go2tv";
    changelog = "https://github.com/alexballas/go2tv/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdamjan ];
    mainProgram = pname;
  };
}
