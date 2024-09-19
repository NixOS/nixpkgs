{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "rime-ice";
  version = "0-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "2ea99c5e4f3afaa24ebef61d17ea097557ca36b3";
    hash = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    rm -rf ./others
    cp -r ./* $out/share/rime-data
  '';

  passthru.updateScript = unstableGitUpdater {
    branch = "main";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Rime 配置：雾凇拼音 | 长期维护的简体词库";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ luochen1990 ];
  };
}
