{
  lib,
  stdenv,
  fetchzip,
  writeText,
  xorgproto,
  libX11,
  libXext,
  libXrandr,
  libxcrypt,
  config,
  conf ? config.slock.conf or null,
  patches ? config.slock.patches or [ ],
  extraLibs ? config.slock.extraLibs or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slock";
  version = "1.6";

  src = fetchzip {
    url = "https://dl.suckless.org/tools/slock-${finalAttrs.version}.tar.gz";
    hash = "sha256-EIzLEIGd631dwYoAe7PXNoki9iaQPP3Y0S5H80aY+l8=";
  };

  buildInputs = [
    xorgproto
    libX11
    libXext
    libXrandr
    libxcrypt
  ]
  ++ extraLibs;

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  preBuild = lib.optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.def.h
  '';

  inherit patches;

  makeFlags = [ "CC:=$(CC)" ];

  passthru.updateScript = gitUpdater {
    url = "git://git.suckless.org/slock";
  };

  meta = {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    mainProgram = "slock";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      qusic
    ];
    platforms = lib.platforms.linux;
  };
})
