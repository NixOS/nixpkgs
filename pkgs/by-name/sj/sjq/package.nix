{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  simdjson,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sjq";
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "sjq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PtAehlzVBpQ/2vkGUgKS0zlsRvSoC4w8W/NLPK8xg6c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    simdjson
  ];

  cmakeFlags = [
    (lib.cmakeBool "SJQ_SYSTEM_SIMDJSON" true)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast JSON processing from the command line with simdjson";
    homepage = "https://simdjson.github.io/sjq/";
    downloadPage = "https://github.com/simdjson/sjq";
    changelog = "https://github.com/simdjson/sjq/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "sjq";
    platforms = lib.platforms.all;
  };
})
