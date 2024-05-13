{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-info";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = "inotify-info";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fsUvIXWnP6Iy9Db0wDG+ntSw6mUt0MQOTJA5vFxhH+U=";
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
