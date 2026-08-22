{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "flakeguard";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "notzorua";
    repo = "flakeguard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AjVWBJz6MFldg5XHlUqGLlslSR5N75UKckmy9FySTSE=";
  };

  vendorHash = null;

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Detect ownership changes of the accounts a flake executes code from";
    longDescription = ''
      A flake input such as `github:someone/tool` means that every build
      downloads and runs code from an account somebody else controls. A typical
      configuration accumulates dozens of these once transitive inputs are
      counted.

      GitHub releases an account name when its owner renames, and anyone can
      then claim it and publish a repository under the old path. This is called
      repojacking. The lock file's narHash protects the pinned revision, but not
      the moment somebody updates the input.

      flakeguard reads flake.lock and reports inputs whose repository is gone,
      moved, archived, stale, or - the case it exists for - whose account was
      created after the commit the lock file pins, which means the name changed
      hands. Depth varies by forge: GitHub needs no credentials, GitLab needs a
      token for the account checks, SourceHut and plain git are limited to
      reachability and staleness.
    '';
    homepage = "https://github.com/notzorua/flakeguard";
    changelog = "https://github.com/notzorua/flakeguard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ notzorua ];
    mainProgram = "flakeguard";
    platforms = lib.platforms.unix;
  };
})
