{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ruby,
  which,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rbspy";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "rbspy";
    repo = "rbspy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H4SFivaMmRvAhJy5n/QZ1dHFRfYywrpABMl1A9waYzo=";
  };

  cargoHash = "sha256-NtUJxQTRmXsI76DjJ43UfBf9FskFk/gehw5STcuQEuQ=";

  doCheck = true;

  # The current implementation of rbspy fails to detect the version of ruby
  # from nixpkgs during tests.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace-fail "/usr/bin/which" "${lib.getExe which}"
    substituteInPlace src/sampler/mod.rs \
      --replace-fail "/usr/bin/which" "${lib.getExe which}"
    substituteInPlace src/core/ruby_spy.rs \
      --replace-fail "/usr/bin/ruby" "${lib.getExe ruby}"
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin rustPlatform.bindgenHook;

  nativeCheckInputs = [
    ruby
    which
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://rbspy.github.io/";
    description = "Sampling CPU Profiler for Ruby";
    mainProgram = "rbspy";
    changelog = "https://github.com/rbspy/rbspy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
