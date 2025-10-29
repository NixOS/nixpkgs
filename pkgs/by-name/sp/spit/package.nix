{
  stdenv,
  lib,
  installShellFiles,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "spit";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "spit";
    tag = "v${version}";
    hash = "sha256-bvcx+bQyi5tWDwuqdOv2h6q1ZSEHO9bHV2lfvRhL7iw=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 spit -t "$out/bin"
    installManPage spit.1
    runHook postInstall
  '';

  meta = {
    description = "Atomically create a file with content";
    platforms = lib.platforms.linux;
    license = lib.licenses.cc0;
    homepage = "https://git.vuxu.org/spit/";
    maintainers = [ lib.maintainers.sternenseemann ];
    mainProgram = "spit";
  };
}
