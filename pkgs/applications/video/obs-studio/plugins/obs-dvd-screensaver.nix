{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-dvd-screensaver";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wimpysworld";
    repo = "obs-dvd-screensaver";
    tag = finalAttrs.version;
    hash = "sha256-eUfy3m0r/sLrGLbp3en1ofcVVWZ+t2rZ4knjwfrorhw=";
  };
  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postPatch = ''
    substituteInPlace src/plugin-main.c \
      --replace-fail 'obs_properties_add_button(props, S_RESET, T_RESET,' 'obs_properties_add_button2(props, S_RESET, T_RESET,' \
      --replace-fail 'reset_logo_position);' 'reset_logo_position, NULL);'
  '';

  meta = {
    description = "DVD screen saver for OBS Studio";
    homepage = "https://github.com/wimpysworld/obs-dvd-screensaver";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
