{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgconf,
  alsa-lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sdroxide";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "dividebysandwich";
    repo = "sdroxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9agV8Y6Vk7CFacm8o6sPJXW23OP+5Ze7kK38QHLmOiU=";
  };

  cargoHash = "sha256-u662PZWoIWdMEfUXiViKu+vs2fagCSZ12P2RYXSx2K4=";

  __structuredAttrs = true;
  buildInputs = [ alsa-lib ];
  nativeBuildInputs = [ pkgconf ];

  meta = {
    description = "A native SDR client for many radios, written in Rust, with native and web remote UI";
    homepage = "https://github.com/dividebysandwich/sdroxide";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nicoo
    ];
  };
})
