{
  lib,
  rustPlatform,
  fetchFromGitHub,
  lm_sensors,
  udevCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "antec-flux-pro-display";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Reikooters";
    repo = "antec-flux-pro-display";
    tag = "v${finalAttrs.version}";
    hash = "sha256-trRSo1SBR2hGXyaDmIz2Ul2JuASzQkq16sQ78Y9kfg8=";
  };
  cargoHash = "sha256-Jl06uXEkkd4z7t8VVf1knr33c8MDiMD9nj1X3XPbEh4=";

  buildInputs = [ lm_sensors ];

  nativeBuildInputs = [ udevCheckHook ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp ${finalAttrs.src}/sample/udev/*.rules $out/etc/udev/rules.d

    # Remove plugdev group in favor of uaccess tag
    sed -i 's/, GROUP="plugdev"//' $out/etc/udev/rules.d/*.rules
  '';

  meta = {
    homepage = "https://github.com/Reikooters/antec-flux-pro-display";
    description = "Antec Flux Pro Hardware Display Service";
    mainProgram = "antec-flux-pro-display";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.kruziikrel13 ];
    platforms = lib.platforms.linux;
  };
})
