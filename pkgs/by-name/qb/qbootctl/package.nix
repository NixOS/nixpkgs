{
  lib,
  fetchFromGitHub,
  linuxHeaders,
  meson,
  ninja,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qbootctl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qbootctl";
    tag = finalAttrs.version;
    hash = "sha256-lpDCU9RJ4pK/qX4dEFfOCEdsF7l4Z/J8wzWMD4orFQY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    linuxHeaders
  ];

  CFLAGS = [ "-I${linuxHeaders}/include" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/linux-msm/qbootctl";
    description = "Qualcomm bootctl HAL for Linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ numinit ];
    platforms = lib.platforms.linux;
    mainProgram = "qbootctl";
  };
})
