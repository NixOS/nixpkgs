{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iw4x-launcher";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "iw4x";
    repo = "launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k1/7E4XKmynHkDWl1LibmaZ2CwXzR4YR3sgCyT+C/ug=";
  };

  cargoHash = "sha256-2czLiNj/GeD8M0hAlAVeoWh4m7vDG9GoLqber9hvwfE=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Official launcher for the IW4x mod";
    longDescription = "IW4x allows you to relive Call of Duty: Modern Warfare 2 (2009) in a secure environment with expanded modding capabilites";
    homepage = "https://iw4x.io";
    downloadPage = "https://github.com/iw4x/launcher";
    changelog = "https://github.com/iw4x/launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "iw4x-launcher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
