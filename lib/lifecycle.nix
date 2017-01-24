let
  stages = context: rec {
    unstable    = { ok = true; };
    stable      = { ok = true; };
    deprecated  = { ok = true; warnMessage = ''
      Version ${context.version} of nixpkgs is depricated!

      This release channel will not be updated after ${context.noUpdatesAfter}.
      Please migrate to release ${context.nextStableVersion}.
    ''; };
    unsupported = { ok = false; abortMessage = ''
      Release ${context.version} is not supported anymore.
      The maintainer will not add security patches anymore.

      If you need to use ${context.version} to reproduce an older setup,
      please pin your nix channel to a specific release.

      For example, if you're building a project with `nix-build`:
      NIX_PATH=nixos=https://github.com/nixos/nixpkgs/archive/$GIT_SHA.tar.gz nix-build -A myprog

      See the manual for more information.
    ''; };
  };
  stage_context = (import ../.release-stage.nix);
  stage = (stages stage_context).${stage_context.stage};
in
{
  checked = passthrough:
    if stage.ok
    then  if stage ? warnMessage
          then builtins.trace stage.warnMessage passthrough
          else passthrough
    else abort stage.abortMessage;
}
