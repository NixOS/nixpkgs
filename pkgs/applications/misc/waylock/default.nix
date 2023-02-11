{ lib
, stdenv
, fetchFromGitHub
, zig
, wayland-scanner
, pkg-config
, scdoc
, wayland
, wayland-protocols
, libxkbcommon
, pam
}:
stdenv.mkDerivation rec {
  pname = "waylock";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jl4jSDWvJB6OfBbVXfVQ7gv/aDkN6bBy+/yK+AQDQL0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ scdoc pkg-config wayland-scanner zig ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    pam
  ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dman-pages -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
