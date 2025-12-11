{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  git,
}:

rustPlatform.buildRustPackage {
  pname = "git-wait";
  version = "0.4.0-unstable-2024-12-01";

  src = fetchFromGitHub {
    owner = "darshanparajuli";
    repo = "git-wait";
    # no tags upstream
    rev = "1d610f694dd1cd4a0970e97b886053ffc7c76244";
    hash = "sha256-Va917eD9M3oUVmLrDab6cx/LvmBlk95U4mRHqPpBB5I=";
  };

  cargoHash = "sha256-tA0WjghBB2K71IlZ1u9K67tZWGe9VNFOfI2YdrqCUw0=";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=tests::wait_if_index_lock_is_present"
  ];

  # versionCheckHook is too complex to use here
  doInstallCheck = true;
  nativeInstallCheckInputs = [ git ];
  installCheckPhase = ''
    runHook preInstallCheck

    stdout=$(set -x; $out/bin/git-wait -v 2>&1)
    if ! grep <<<"$stdout" -q ${lib.escapeShellArg git.version}; then
      >&2 echo "ERROR: version check failed!" ${lib.escapeShellArg git.version} "was not found."
      >&2 echo "Output was"
      >&2 echo "$stdout"
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Simple git wrapper that waits until index.lock file is removed when present before running the command";
    homepage = "https://github.com/darshanparajuli/git-wait";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "git-wait";
  };
}
