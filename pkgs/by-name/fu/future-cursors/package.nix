{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "future-cursors";
  version = "0-unstable-2021-07-16";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Future-cursors";
    rev = "587c14d2f5bd2dc34095a4efbb1a729eb72a1d36";
    hash = "sha256-ziEgMasNVhfzqeURjYJK1l5BeIHk8GK6C4ONHQR7FyY=";
  };

  installPhase = ''
    runHook preInstall
    install -dm 755 $out/share/icons/Future-cursors
    cp -r dist/* $out/share/icons/Future-cursors/
    runHook postInstall
  '';

  meta = {
    description = "Future cursor theme";
    homepage = "https://github.com/yeyushengfan258/Future-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ epic9491 ];
  };
})
