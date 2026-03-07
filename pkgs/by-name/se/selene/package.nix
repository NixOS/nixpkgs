{
  lib,
  rustPlatform,
  fetchFromGitHub,
  robloxSupport ? true,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "selene";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = "selene";
    tag = finalAttrs.version;
    hash = "sha256-6NjEE5r9vILnWIyALN8b3aiYWJ9hGzAoYEv+lxNL32Y=";
  };

  cargoHash = "sha256-0BZroMbaRtpfOf2p33S830T2V+/eobezX0HVsZ/qtnI=";

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs = lib.optionals robloxSupport [
    openssl
  ];

  buildNoDefaultFeatures = !robloxSupport;

  meta = {
    description = "Blazing-fast modern Lua linter written in Rust";
    mainProgram = "selene";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
