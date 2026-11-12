{
  buildEnv,
  makeWrapper,
  iortcw_sp,
}:

let
  mp = iortcw_sp.overrideAttrs (oldAttrs: {
    pname = "iortcw-mp";
    sourceRoot = "${oldAttrs.src.name}/MP";
    passthru = oldAttrs.passthru // {
      executables = [
        "iowolfded"
        "iowolfmp"
      ];
    };
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
  postBuild = iortcw_sp.postInstall + mp.postInstall;

  meta = iortcw_sp.meta // {
    description = "Game engine for Return to Castle Wolfenstein";
  };
}
