{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "holo-daemon";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zZrse46NJb8gD4BtM20FfdtRdxVNLZ+/51dy2nuiOd8=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-cHJzwI7FDVA1iwqg+x9sMlao22SGQoOuq+MB0XtYsEc=";

  # Use rust nightly features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];
  buildInputs = [
    pcre2
  ];

  meta = {
    description = "`holo` daemon that provides the routing protocols, tools and policies";
    homepage = "https://github.com/holo-routing/holo";
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
    license = lib.licenses.mit;
    mainProgram = "holod";
    platforms = lib.platforms.linux;
  };
})
