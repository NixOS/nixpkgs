{
  buildEnv,
  makeWrapper,
  iortcw_sp,
}:

let
  mp = iortcw_sp.overrideAttrs (oldAttrs: {
    sourceRoot = "${oldAttrs.src.name}/MP";
  });
in
buildEnv {
  inherit (iortcw_sp) version;
  pname = "iortcw";

  paths = [
    iortcw_sp
    mp
  ];

  pathsToLink = [ "/opt" ];

  nativeBuildInputs = [ makeWrapper ];

  # so we can launch sp from mp game and vice versa
  postBuild = ''
    for i in `find -L $out/opt/iortcw -maxdepth 1 -type f -executable`; do
      makeWrapper $i $out/bin/`basename $i` --chdir "$out/opt/iortcw"
    done
  '';

  meta = iortcw_sp.meta // {
    description = "Game engine for Return to Castle Wolfenstein";
  };
}
