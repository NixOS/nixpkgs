{
  lib,
  millennium,
  steam,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraProfile ? "",
  extraPreBwrapCmds ? "",
  extraBwrapArgs ? [ ],
  extraArgs ? "",
  extraEnv ? { },
  privateTmp ? true,
  ...
}:
(steam.override (prevArgs: {
  extraPkgs = pkgs: (prevArgs.extraPkgs or (_: [ ])) pkgs ++ extraPkgs pkgs;
  extraPreBwrapCmds = (prevArgs.extraPreBwrapCmds or "") + extraPreBwrapCmds;
  extraBwrapArgs = (prevArgs.extraBwrapArgs or [ ]) ++ extraBwrapArgs;
  extraArgs = (prevArgs.extraArgs or "") + extraArgs;
  extraEnv = (prevArgs.extraEnv or { }) // extraEnv;

  # If privateTmp is false (the non-default value) in either the steam package or this package, use false
  privateTmp = (prevArgs.privateTmp or true) && privateTmp;

  extraLibraries =
    pkgs: (prevArgs.extraLibraries or (_: [ ])) pkgs ++ extraLibraries pkgs ++ [ millennium ];

  extraProfile =
    (prevArgs.extraProfile or "")
    + extraProfile
    + ''
      ln -sf ${millennium}/lib/libmillennium_bootstrap_x86.so "$HOME/.local/share/Steam/ubuntu12_32/libXtst.so.6"
      ln -sf ${millennium}/lib/libmillennium_bootstrap_hhx64.so "$HOME/.local/share/Steam/ubuntu12_64/libXtst.so.6"
    '';
})).overrideAttrs
  (old: {
    pname = "steam-with-millennium";
    meta = old.meta // {
      description = "${old.meta.description} (with Millennium theming support)";
      maintainers = [ lib.maintainers.DrymarchonShaun ];
      teams = [ ];
    };
  })
