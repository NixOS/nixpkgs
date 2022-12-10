{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  wayland,
  pkg-config,
  scdoc,
  wayland-protocols,
  libxkbcommon,
  pam,
}:
stdenv.mkDerivation rec {
  pname = "waylock";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yWjWcnGa4a+Dpc82H65yr8H7v88g/tDq0FSguubhbEI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [zig wayland scdoc pkg-config];

  buildInputs = [
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
    zig build -Drelease-safe -Dman-pages --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [jordanisaacs];
  };
}
