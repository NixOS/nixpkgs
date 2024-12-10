{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "havoc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ii8";
    repo = "havoc";
    rev = finalAttrs.version;
    hash = "sha256-jvGm2gFdMS61otETF7gOEpYn6IuLfqI95IpEVfIv+C4=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    wayland-protocols
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  dontConfigure = true;

  installFlags = [ "PREFIX=$$out" ];

  postInstall = ''
    install -Dm 644 havoc.cfg -t $out/etc/havoc/
    install -Dm 644 README.md -t $out/share/doc/havoc-${finalAttrs.version}/
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ii8/havoc";
    description = "A minimal terminal emulator for Wayland";
    license = with lib.licenses; [
      mit
      publicDomain
    ];
    mainProgram = "havoc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin; # fatal error: 'sys/epoll.h' file not found
  };
})
