{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-info";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = "inotify-info";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6EY2cyFWfMy1hPDdDGwIzSE92VkAPo0p5ZCG+B1wVYY=";
  };

  buildFlags = ["INOTIFYINFO_VERSION=v${finalAttrs.version}"];

  installPhase = ''
    runHook preInstall
    install -Dm755 _release/inotify-info $out/bin/inotify-info
    runHook postInstall
  '';

  meta = with lib; {
    description = "Easily track down the number of inotify watches, instances, and which files are being watched";
    homepage = "https://github.com/mikesart/inotify-info";
    license = licenses.mit;
    mainProgram = "inotify-info";
    maintainers = with maintainers; [ motiejus ];
    platforms = platforms.linux;
  };
})
