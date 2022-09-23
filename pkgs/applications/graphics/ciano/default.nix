{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, ffmpeg
, gobject-introspection
, granite
, gtk
, imagemagick
, libgee
, libhandy
, libsecret
, libsoup
, meson
, ninja
, pkg-config
, python
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ciano";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "robertsanseries";
    repo = pname;
    rev = version;
    hash = "sha256-nubm6vBWwsHrrmvFAL/cIzYPxg9B1EhnpC79IJMNuFY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    ffmpeg
    imagemagick
    granite
    gtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  dontWrapGApps = true;

  postFixup = let
    binPath = lib.makeBinPath [
      ffmpeg
      imagemagick
    ];
  in
    ''
      wrapProgram $out/bin/com.github.robertsanseries.ciano \
         --prefix PATH : ${binPath} "''${gappsWrapperArgs[@]}"
      ln -s $out/bin/com.github.robertsanseries.ciano $out/bin/ciano
    '';

  meta = with lib; {
    homepage = "https://github.com/robertsanseries/ciano";
    description = "A multimedia file converter focused on simplicity";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
