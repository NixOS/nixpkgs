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
    owner = "muennich";
    repo = "physlock";
    rev = "v${finalAttrs.version}";
    sha256 = "1mz4xxjip5ldiw9jgfq9zvqb6w10bcjfx6939w1appqg8f521a7s";
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
    mainProgram = "physlock";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
