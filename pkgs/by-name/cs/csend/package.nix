{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csend";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "matthewdeaves";
    repo = "csend";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v0vTdbMquB4xC/8bJ8nlSaRoxUGb0LWiPD344z7ljYA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv build/posix/csend_posix $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Peer-to-peer (P2P) chat application designed to run on both modern POSIX-compliant systems";
    longDescription = "A peer-to-peer (P2P) chat application designed to run on both modern POSIX-compliant systems (Linux, macOS) and vintage Classic Macintosh computers (System 7.5.3/MacTCP, built with Retro68). Features UDP-based peer discovery and TCP-based text messaging using a simple custom protocol. Includes Docker support for the POSIX version";
    homepage = "https://github.com/matthewdeaves/csend";
    # https://github.com/matthewdeaves/csend/issues/44
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "csend_posix";
    platforms = lib.platforms.unix;
  };
})
