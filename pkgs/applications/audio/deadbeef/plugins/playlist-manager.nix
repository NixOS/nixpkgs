{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  deadbeef,
  gtk3,
}:

stdenv.mkDerivation {
  pname = "deadbeef-playlist-manager-plugin";
  version = "unstable-2021-05-02";

  src = fetchFromGitHub {
    owner = "kpcee";
    repo = "deadbeef-playlist-manager";
    rev = "b1393022b2d9ea0a19b845420146e0fc56cd9c0a";
    sha256 = "sha256-dsKthlQ0EuX4VhO8K9VTyX3zN8ytzDUbSi/xSMB4xRw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    deadbeef
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef/
    cp *.so $out/lib/deadbeef/

    runHook postInstall
  '';

  buildFlags = [
    "CFLAGS=-I${deadbeef}/include/deadbeef"
    "gtk3"
  ];

  meta = with lib; {
    description = "Removes duplicate and vanished files from the current playlist";
    homepage = "https://github.com/kpcee/deadbeef-playlist-manager";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.cmm ];
    platforms = platforms.linux;
  };
}
