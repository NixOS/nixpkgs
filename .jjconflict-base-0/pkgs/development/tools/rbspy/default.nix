{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ruby
, which
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "rbspy";
    repo = "rbspy";
    rev = "refs/tags/v${version}";
    hash = "sha256-K5zDM7HhSNklCMoj3yh5lf0HTITOl2UYXW0QCxDF2GU=";
  };

  cargoHash = "sha256-2yYv7Pp6UqHTPrmG4BM0py3GoPYYJW7e9LQSrgxx/3A=";

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
  '';

  checkFlags = [
    "--skip=test_get_trace"
    "--skip=test_get_trace_when_process_has_exited"
    "--skip=test_sample_single_process"
    "--skip=test_sample_single_process_with_time_limit"
    "--skip=test_sample_subprocesses"
  ];

  nativeBuildInputs = [
    ruby
    which
  ] ++ lib.optional stdenv.hostPlatform.isDarwin rustPlatform.bindgenHook;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://rbspy.github.io/";
    description = "Sampling CPU Profiler for Ruby";
    mainProgram = "rbspy";
    changelog = "https://github.com/rbspy/rbspy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
