{
  lib,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkgconf,
  alsa-lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sdroxide";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dividebysandwich";
    repo = "sdroxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-obVqYyrZRzKpt2/LU0T6XPg8wa6GdegLy3NykAHCHl0=";
  };

  # HACK: the deep_filter crate include_bytes! from its workspace
  #  (but outside its directory) which fetchCargoVendor cannot handle
  prePatch = let
    model = fetchurl {
      url = "https://github.com/Rikorose/DeepFilterNet/raw/978576aa8400552a4ce9730838c635aa30db5e61/models/DeepFilterNet3_onnx.tar.gz";
      hash = "sha256-yU2R9wkRAByUbg+rtKqa3DcEX0WgO1YAjLDIJEy2NhY=";
    };
  in ''
    mkdir ../sdroxide-1.5.0-vendor/source-git-0/models
    ln -s ${model} ../sdroxide-1.5.0-vendor/source-git-0/models/DeepFilterNet3_onnx.tar.gz
  '';

  cargoHash = "sha256-RChkuoXZ/Ex45P+D+9t2ZQ2JPM3O06DpkFyrSCOe/9s=";

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
