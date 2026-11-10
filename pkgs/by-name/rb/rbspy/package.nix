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
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "rbspy";
    repo = "rbspy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RedYnOggCA0ET9K204XE4TVAB/bb9sqDg0uKFp8kswk=";
  };

  cargoHash = "sha256-9vjL+8fHOwD5dyV8OpBHn1xrn+oEy49bS89kd3Nj8OY=";

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
