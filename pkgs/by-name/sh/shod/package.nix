{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  fontconfig,
  libx11,
  libxft,
  libxpm,
  libxrandr,
  libxrender,
  conf ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shod";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "shod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0bKp1BTIdYVBDVdeGnTVo76UtBxa4UbXLZihdjHS/og=";
  };

  buildInputs = [
    fontconfig
    libx11
    libxft
    libxpm
    libxrandr
    libxrender
  ];

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.h";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Mouse-based window manager that can tile windows inside floating containers";
    longDescription = ''
      shod is a multi-monitor floating reparenting X11 window manager that
      supports tiled and tabbed containers. shod sets no keybindings, reads no
      configuration, and works only via mouse with a given key modifier (Alt by
      default) and by responding to client messages sent by the shodc utility
      (shod's remote controller).
    '';
    homepage = "https://github.com/phillbush/shod";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
