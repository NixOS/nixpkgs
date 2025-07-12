{
  lib,
  stdenv,
  fetchurl,
  fontconfig,
  libX11,
  libXinerama,
  libXft,
  zlib,
  writeText,
  # customization
  config,
  conf ? config.dmenu.conf or null,
  extraLibs ? config.dmenu.extraLibs or [ ],
  patches ? config.dmenu.patches or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "dmenu";
  version = "5.3";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/dmenu-${version}.tar.gz";
    sha256 = "sha256-Go9T5v0tdJg57IcMXiez4U2lw+6sv8uUXRWeHVQzeV8=";
  };

  buildInputs = [
    fontconfig
    libX11
    libXinerama
    zlib
    libXft
  ] ++ extraLibs;

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

  meta = with lib; {
    description = "Generic, highly customizable, and efficient menu for the X Window System";
    homepage = "https://tools.suckless.org/dmenu";
    license = licenses.mit;
    maintainers = with maintainers; [
      pSub
      globin
      qusic
      _0david0mp
    ];
    platforms = platforms.all;
    mainProgram = "dmenu";
  };
}
