{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sinkzone";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "berbyte";
    repo = "sinkzone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CYVaqtTvAGlN6o5gZxGgc+a25x5PlVmQEPYDBF9pehw=";
  };

  vendorHash = "sha256-JZwkL+EFCMP8m5wRVmARrAhfHy2/uAC74/f9PGYR4eg=";

  # Patch man page path
  postPatch = ''
    substituteInPlace cmd/man.go \
      --replace-fail 'filepath.Join(execDir, "docs", "sinkzone.1")' \
                     '"${placeholder "out"}/share/man/man1/sinkzone.1.gz"' \
      --replace-fail 'execDir :=' '_ =' # skip err: declared and not used
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    install -Dm444 docs/${finalAttrs.meta.mainProgram}.1 \
      --target-directory=$out/share/man/man1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DNS-based productivity tool that blocks distractions and helps you stay focused";
    longDescription = ''
      The internet is infinite. Your focus isn’t. Sinkzone helps you
      reclaim control by flipping the default: everything is blocked,
      unless you explicitly allow it. No feeds. No pings. No surprise
      connections. Allowlist-only internet for distraction-free work
    '';
    homepage = "https://github.com/berbyte/sinkzone";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "sinkzone";
  };
})
