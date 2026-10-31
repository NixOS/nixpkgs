{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshp";
  version = "1.1.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = "sshp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5sVXBqu/bqBCf7FjT7WxirrVG8XX9461jNdpNY31RXQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -D sshp "$out/bin/sshp"
    installManPage man/sshp.1
    runHook postInstall
  '';

  meta = {
    description = "Parallel SSH Executor";
    mainProgram = "sshp";
    longDescription = ''
      sshp manages multiple ssh processes and handles coalescing the output to the terminal.
      By default, sshp will read a file of newline-separated hostnames or IPs and fork ssh
      subprocesses for them, redirecting the stdout and stderr streams of the child
      line-by-line to stdout of sshp itself.
    '';
    homepage = "https://github.com/bahamas10/sshp";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin ++ freebsd;
    maintainers = with lib.maintainers; [ theCapypara ];
  };
})
