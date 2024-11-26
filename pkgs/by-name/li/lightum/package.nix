{ lib, stdenv, fetchFromGitHub, libX11, libXScrnSaver, libXext, glib, dbus, pkg-config, systemd }:

stdenv.mkDerivation {
  pname = "lightum";
  version = "unstable-2014-06-07";

  src = fetchFromGitHub {
    owner = "poliva";
    repo = "lightum";
    rev = "123e6babe0669b23d4c1dfa5511088608ff2baa8";
    sha256 = "sha256-dzWUVY2srgk6BM6jZ7FF+snxnPopz3fx9nq+mVkmogc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    glib
    libX11
    libXScrnSaver
    libXext
    systemd
  ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "libsystemd-login" "libsystemd"
  '';

  installPhase = ''
    make install prefix=$out bindir=$out/bin docdir=$out/share/doc \
      mandir=$out/share/man INSTALL="install -c" INSTALLDATA="install -c -m 644"
  '';

  meta = {
    description = "MacBook automatic light sensor daemon";
    mainProgram = "lightum";
    homepage = "https://github.com/poliva/lightum";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.linux;
  };
}
