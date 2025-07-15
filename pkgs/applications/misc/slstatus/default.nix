{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  writeText,
  libX11,
  libXau,
  libXdmcp,
  conf ? null,
  patches ? [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "slstatus";
  version = "1.1";

  src = fetchgit {
    url = "https://git.suckless.org/slstatus";
    rev = version;
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
    libXau
    libXdmcp
  ];

  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://tools.suckless.org/slstatus/";
    description = "status monitor for window managers that use WM_NAME like dwm";
    license = licenses.isc;
    maintainers = with maintainers; [
      oxzi
      qusic
    ];
    platforms = platforms.linux;
    mainProgram = "slstatus";
  };
}
