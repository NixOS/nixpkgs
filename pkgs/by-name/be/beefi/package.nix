{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  binutils-unwrapped,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beefi";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jfeick";
    repo = "beefi";
    tag = finalAttrs.version;
    hash = "sha256-ZRPQAoIXh2LZxonPAAjwaY73E3sNO/sCJoHwRdVWAIU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    binutils-unwrapped
    systemd
  ];

  patchPhase = ''
    substituteInPlace beefi \
      --replace objcopy ${binutils-unwrapped}/bin/objcopy \
      --replace /usr/lib/systemd ${systemd}/lib/systemd
  '';

  installPhase = ''
    install -Dm755 beefi $out/bin/beefi
    installManPage beefi.1
  '';

  meta = {
    description = "Small script to create bootable EFISTUB kernel images";
    mainProgram = "beefi";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tu-maurice ];
    homepage = "https://github.com/jfeick/beefi";
  };
})
