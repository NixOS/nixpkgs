{
  lib,
  stdenv,
  fetchFromGitHub,
  pam,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "13";
  pname = "physlock";
  src = fetchFromGitHub {
    owner = "xyb3rt";
    repo = "physlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+qggikMP36sCTyOZ7iRbIHCz8P4JuycTj42WG2Xv5Nc=";
  };

  buildInputs = [
    pam
    systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "-m 4755 -o root -g root" ""
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SESSION=systemd"
  ];

  meta = {
    description = "Secure suspend/hibernate-friendly alternative to `vlock -an`";
    homepage = "https://github.com/xyb3rt/physlock";
    mainProgram = "physlock";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
