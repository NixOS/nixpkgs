{
  lib,
  symlinkJoin,
  makeWrapper,
  npb-unwrapped,

  git,
  nix,
  nix-eval-jobs,
  nix-output-monitor,
}:
symlinkJoin (finalAttrs: {
  pname = "npb";
  inherit (npb-unwrapped) version;

  strictDeps = true;
  __structuredAttrs = true;

  paths = [ npb-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/npb \
      --prefix PATH : "${lib.makeBinPath finalAttrs.passthru.runtimeDeps}"
  '';

  passthru = {
    runtimeDeps = [
      nix
      nix-eval-jobs
      nix-output-monitor
      git
    ];
  };

  meta = {
    inherit (npb-unwrapped.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      ;
  };
})
