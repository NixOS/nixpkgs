{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-info";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = "inotify-info";
    rev = "a7ff6fa62ed96ec5d2195ef00756cd8ffbf23ae1";
    hash = "sha256-yY+hjdb5J6dpFkIMMUWvZlwoGT/jqOuQIcFp3Dv+qB8=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 _release/inotify-info $out/bin/inotify-info
    runHook postInstall
  '';

  meta = with lib; {
    description = "Easily track down the number of inotify watches, instances, and which files are being watched.";
    homepage = "https://github.com/mikesart/inotify-info";
    license = licenses.mit;
    mainProgram = "inotify-info";
    maintainers = with maintainers; [ motiejus ];
    platforms = platforms.linux;
  };
})
