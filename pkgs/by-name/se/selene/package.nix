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
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = "selene";
    tag = finalAttrs.version;
    hash = "sha256-zsqgLE9igxGGjymMJSt6JR453bw63TWeZwRVmkDm6ag=";
  };

  cargoHash = "sha256-RxIDFE+FGKUDvM1Fy/doSy/mf2JuklhoMGpSqoHhAV4=";

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
