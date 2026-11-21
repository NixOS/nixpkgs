{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sinkzone";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "berbyte";
    repo = "sinkzone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CYVaqtTvAGlN6o5gZxGgc+a25x5PlVmQEPYDBF9pehw=";
  };

  vendorHash = "sha256-JZwkL+EFCMP8m5wRVmARrAhfHy2/uAC74/f9PGYR4eg=";

  # Read the installed man page instead of one relative to the working directory
  postPatch = ''
    substituteInPlace cmd/man.go \
      --replace-fail '"docs/sinkzone.1"' \
                     '"${placeholder "out"}/share/man/man1/sinkzone.1"'
  '';

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" ];

  postInstall = ''
    installManPage docs/sinkzone.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sinkzone \
      --bash <($out/bin/sinkzone completion bash) \
      --fish <($out/bin/sinkzone completion fish) \
      --zsh <($out/bin/sinkzone completion zsh)
  '';

  # Keep the man page readable by the built-in fallback when man is missing
  dontGzipMan = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DNS-based productivity tool that blocks distractions and helps you stay focused";
    longDescription = ''
      Sinkzone is a local DNS resolver that enforces an allowlist during
      focus sessions.  Every DNS request is blocked unless the domain is
      explicitly allowed, which leaves no feeds, notifications or
      unexpected connections while you work.
    '';
    homepage = "https://github.com/berbyte/sinkzone";
    changelog = "https://github.com/berbyte/sinkzone/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "sinkzone";
  };
})
