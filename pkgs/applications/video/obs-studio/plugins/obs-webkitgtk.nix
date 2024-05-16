{ lib
, stdenv
, fetchFromGitHub
, obs-studio
, webkitgtk
, glib-networking
, meson
, cmake
, pkg-config
, ninja
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "obs-webkitgtk";
  version = "unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-webkitgtk";
    rev = "ddf230852c3c338e69b248bdf453a0630f1298a7";
    hash = "sha256-DU2w9dRgqWniTE76KTAtFdxIN82VKa/CS6ZdfNcTMto=";
  };

  buildInputs = [
    obs-studio
    webkitgtk
    glib-networking
  ];

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
    wrapGAppsHook3
  ];

  postPatch = ''
    substituteInPlace ./obs-webkitgtk.c \
      --replace 'g_file_read_link("/proc/self/exe", NULL)' "g_strdup(\"$out/lib/obs-plugins\")"
  '';

  meta = with lib; {
    description = "Yet another OBS Studio browser source";
    homepage = "https://github.com/fzwoch/obs-webkitgtk";
    maintainers = with maintainers; [ j-hui ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
