{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  replaceVars,
  cmake,
  pkg-config,
  protobuf,
  pcre2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "holo-cli";
  version = "0.5.0-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "holo-routing";
    repo = "holo-cli";
    rev = "8a8f02fc56f30cca216e9a99029b736fe57b3d59";
    hash = "sha256-pCupXT4fymydzOpdsMbimAcQZzVUNzfG3VRnrD3q7Xw=";
  };

  cargoHash = "sha256-7/OtT2TdLhFVZeuQOg6xQJFnGJNz/G9mna8vIeh86/k=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    pushd $cargoDepsCopy/libyang4-sys-*
    patch -p1 < ${
      replaceVars ./libyang4-sys.patch {
        PCRE2_INCLUDE_DIRS = "${lib.getInclude pcre2}/include";
        PCRE2_LIBRARIES = "${lib.getLib pcre2}/lib/libpcre2-8${stdenv.hostPlatform.extensions.sharedLibrary}";
      }
    }
    popd
  '';

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
    description = "Holo` Command Line Interface";
    homepage = "https://github.com/holo-routing/holo-cli";
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
    license = lib.licenses.mit;
    mainProgram = "holo-cli";
    platforms = lib.platforms.all;
  };
})
