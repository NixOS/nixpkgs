{
  cmake,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "realm";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P7jyVe6KNe1evan2qRtpA99ZKbgF1Zz7DiRxi1+h7WI=";
  };

  cargoHash = "sha256-kuoYEGn419LtJRGoWzlvgclkjW0zh94XX6OvCsa5Hfc=";

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  env.RUSTC_BOOTSTRAP = 1;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) realm; };
  };

  meta = {
    description = "Simple, high performance relay server written in rust";
    homepage = "https://github.com/zhboner/realm";
    mainProgram = "realm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ocfox ];
  };
})
