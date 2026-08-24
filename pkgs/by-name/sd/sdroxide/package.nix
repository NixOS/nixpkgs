{
  lib,
  fetchFromGitHub,
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
