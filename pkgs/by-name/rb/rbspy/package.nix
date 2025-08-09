{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  ruby,
  which,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "rbspy";
    repo = "rbspy";
    tag = "v${version}";
    hash = "sha256-yVcVuMCyvk9RbkbKomqjkLY+p5tUzW2zcAKZ8XfsjM0=";
  };

  cargoHash = "sha256-WiIHFwB6BE9VYuC2dCHNnrEFjVsesp0c5i4bH01cXis=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

  doCheck = true;

  # The current implementation of rbspy fails to detect the version of ruby
  # from nixpkgs during tests.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/sampler/mod.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/core/ruby_spy.rs \
      --replace /usr/bin/ruby '${ruby}/bin/ruby'
  '';

  checkFlags = [
    "--skip=test_get_trace"
    "--skip=test_get_trace_when_process_has_exited"
    "--skip=test_sample_single_process"
    "--skip=test_sample_single_process_with_time_limit"
    "--skip=test_sample_subprocesses"
  ];

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
    changelog = "https://github.com/rbspy/rbspy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
