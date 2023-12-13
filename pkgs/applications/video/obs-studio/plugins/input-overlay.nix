{ stdenv, lib
, fetchFromGitHub
, cmake
, pkg-config
, obs-studio
, libuiohook
, qtbase
, xorg
, libxkbcommon
, libxkbfile
}:

stdenv.mkDerivation rec {
  pname = "obs-input-overlay";
  version = "5.0.0";
  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "v${version}";
    sha256 = "sha256-kpVAvQpBU8TxHAFcx/ok67++4MHh5saoRHJc5XpY4YQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    obs-studio libuiohook qtbase
    xorg.libX11 xorg.libXau xorg.libXdmcp xorg.libXtst xorg.libXext
    xorg.libXi xorg.libXt xorg.libXinerama libxkbcommon libxkbfile
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Show keyboard, gamepad and mouse input on stream ";
    homepage = "https://github.com/univrsal/input-overlay";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
