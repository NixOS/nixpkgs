{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorg,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libXNVCtrl";
  version = "565.77";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-settings";
    tag = version;
    hash = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
  };

  patches = [
    ./0001-libxnvctrl_so.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11.dev
    xorg.libXext.dev
  ];
  enableParallelBuilding = true;

  sourceRoot = "${src.name}/src/libXNVCtrl";

  installPhase = ''
    mkdir -p $out/include $out/lib
    install -Dm 644 *.h -t "$out/include/NVCtrl"
    cp -Pr _out/*/libXNVCtrl.* -t "$out/lib"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "NVIDIA NV-CONTROL X extension";
    homepage = "https://github.com/NVIDIA/nvidia-settings";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ners ];
  };
}
