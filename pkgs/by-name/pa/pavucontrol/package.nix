{
  fetchFromGitLab,
  lib,
  stdenv,
  pkg-config,
  intltool,
  libpulseaudio,
  gtkmm4,
  libsigcxx,
  # Since version 6.1, libcanberra is optional
  withLibcanberra ? true,
  libcanberra-gtk3,
  json-glib,
  adwaita-icon-theme,
  wrapGAppsHook4,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavucontrol";
<<<<<<< HEAD
  version = "6.2";
=======
  version = "6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = "pavucontrol";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-If76Qt2BFgGMYt2PSzDQWmNPsbzneZ6zW9yYnS3lo84=";
=======
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cru4I+LljYKIpIr7gSolnuLuUIXgc8l+JUmPrme4+YA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    libpulseaudio
    gtkmm4
    libsigcxx
    (lib.optionals withLibcanberra libcanberra-gtk3)
    json-glib
    adwaita-icon-theme
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook4
    meson
    ninja
  ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
<<<<<<< HEAD
    (lib.mesonEnable "lynx" false)
=======
    (lib.mesonBool "lynx" false)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  enableParallelBuilding = true;

  meta = {
    changelog = "https://freedesktop.org/software/pulseaudio/pavucontrol/#news";
    description = "PulseAudio Volume Control";
    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';
    mainProgram = "pavucontrol";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
