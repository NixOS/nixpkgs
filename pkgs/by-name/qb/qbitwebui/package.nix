{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "qbitwebui";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Maciejonos";
    repo = "qbitwebui";
    rev = "895ccae94cd46cb6b76b21cd336f785543fff66f";
    hash = "sha256-/OX6RWCDvdNXRWWJ+t6Ez//7IcR0egHks7gfdAuKnLY=";
  };

  npmDepsHash = "sha256-G1Cq8iXXx8dt4l9wK4okmXWsOF1pkcKXLfvv+BxtIZ0=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/qbitwebui
    cp -r dist $out/share/qbitwebui/public
    echo "${finalAttrs.version}" > $out/share/qbitwebui/version.txt

    runHook postInstall
  '';

  meta = {
    description = "Modern frontend for qBittorrent";
    homepage = "https://github.com/Maciejonos/qbitwebui";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ valyntyler ];
  };
})
