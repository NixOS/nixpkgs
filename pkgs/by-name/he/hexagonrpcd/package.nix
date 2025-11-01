{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hexagonrpcd";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "hexagonrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OC6wXBCIW4XznWG0zzxRK3BzWMVK2Jq/gTL36sJV1PE=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qualcomm HexagonFS daemon";
    homepage = "https://github.com/linux-msm/hexagonrpc";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "hexagonrpcd";
  };
})
