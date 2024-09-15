{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, Carbon
, Cocoa
, Kernel
, UserNotifications
, xorg
, libglvnd
, pkg-config
, withGui ? true
}:

buildGoModule rec {
  pname = "go2tv" + lib.optionalString (!withGui) "-lite";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "alexballas";
    repo = "go2tv";
    rev = "refs/tags/v${version}";
    hash = "sha256-h0q2VhnU7CPCD0Co9rLPmGh4BK4eP5QUMep7AaJ3weY=";
  };

  vendorHash = "sha256-+sASY+HosTMMVHHPwVw8nO+/72s2A1EpuTMHJXhHtnc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXext
    xorg.libXxf86vm
    libglvnd
  ] ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa Kernel UserNotifications ];

  ldflags = [
    "-s"
    "-w"
    "-linkmode=external"
  ];

  # conditionally build with GUI or not (go2tv or go2tv-lite sub-packages)
  subPackages = [ "cmd/${pname}" ];

  doCheck = false;

  meta = with lib; {
    description = "Cast media files to UPnP/DLNA Media Renderers and Smart TVs";
    homepage = "https://github.com/alexballas/go2tv";
    changelog = "https://github.com/alexballas/go2tv/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gdamjan ];
    mainProgram = "go2tv";
  };
}
