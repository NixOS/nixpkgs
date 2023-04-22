{ lib
, stdenv
, fetchFromGitHub
, libxkbcommon
, pkg-config
, wayland-protocols
, wayland-scanner
, wayland
}:

stdenv.mkDerivation rec {
  pname = "havoc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ii8";
    repo = pname;
    rev = version;
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
    install -D -m 644 havoc.cfg -t $out/etc/${pname}/
    install -D -m 644 README.md -t $out/share/doc/${pname}-${version}/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ii8/havoc";
    description = "A minimal terminal emulator for Wayland";
    license = with licenses; [ mit publicDomain ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
    # fatal error: 'sys/epoll.h' file not found
    broken = stdenv.isDarwin;
  };
}
