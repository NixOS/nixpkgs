{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  writeText,
  libX11,
  libxcb,
  libXau,
  libXdmcp,
  config,
  conf ? config.slstatus.conf or null,
  patches ? config.slstatus.patches or [ ],
  extraLibs ? config.slstatus.extraLibs or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slstatus";
  version = "1.1";

  src = fetchzip {
    url = "https://dl.suckless.org/tools/slstatus-${finalAttrs.version}.tar.gz";
    hash = "sha256-MRDovZpQsvnLEvsbJNBzprkzQQ4nIs1T9BLT+tSGta8=";
  };

  preBuild =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
    in
    ''
      ${lib.optionalString (conf != null) "cp ${configFile} config.def.h"}
      makeFlagsArray+=(LDLIBS="-lX11 -lxcb -lXau -lXdmcp" CC=$CC)
    '';

  inherit patches;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    libxcb
    libXau
    libXdmcp
  ]
  ++ extraLibs;

  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://tools.suckless.org/slstatus/";
    description = "Status monitor for window managers that use WM_NAME like dwm";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      oxzi
      qusic
    ];
    platforms = lib.platforms.linux;
    mainProgram = "slstatus";
  };
})
