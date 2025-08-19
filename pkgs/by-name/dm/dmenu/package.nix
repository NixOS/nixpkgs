{
  lib,
  stdenv,
  fetchzip,
  fontconfig,
  libX11,
  libXinerama,
  libXft,
  writeText,
  # customization
  config,
  conf ? config.dmenu.conf or null,
  extraLibs ? config.dmenu.extraLibs or [ ],
  patches ? config.dmenu.patches or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmenu";
  version = "5.4";

  src = fetchzip {
    url = "https://dl.suckless.org/tools/dmenu-${finalAttrs.version}.tar.gz";
    hash = "sha256-6bFq3Pj3cuZqLR0pkoJyfx3CDWmmSqkDoEVptMfej7g=";
  };

  buildInputs = [
    fontconfig
    libX11
    libXinerama
    libXft
  ]
  ++ extraLibs;

  inherit patches;

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
    in
    ''
      sed -ri -e 's!\<(dmenu|dmenu_path|stest)\>!'"$out/bin"'/&!g' dmenu_run
      sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu_path
      ${lib.optionalString (conf != null) "cp ${configFile} config.def.h"}
    '';

  preConfigure = ''
    makeFlagsArray+=(
      PREFIX="$out"
      CC="$CC"
    )
  '';

  passthru.updateScript = gitUpdater { url = "git://git.suckless.org/dmenu"; };

  meta = {
    description = "Generic, highly customizable, and efficient menu for the X Window System";
    homepage = "https://tools.suckless.org/dmenu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pSub
      globin
      qusic
      _0david0mp
    ];
    platforms = lib.platforms.all;
    mainProgram = "dmenu";
  };
})
