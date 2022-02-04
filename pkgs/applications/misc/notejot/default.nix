{ lib
, stdenv
, fetchFromGitHub
, gtk4
, hicolor-icon-theme
, json-glib
, libadwaita
, libgee
, meson
, ninja
, nix-update-script
, pkg-config
, python3
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "3.3.3"; # make sure to recheck src.rev

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    # Note from Fedora spec file:
    # https://src.fedoraproject.org/rpms/notejot/blob/bbe621cef4d5a2c27eed029063b8e8cfd7c8d400/f/notejot.spec
    # Upstream confusingly made several bugfix post-releases of version 3.3.3,
    # tagged as 3.4.x, but with prominent notices like "This is still 3.3.3". We
    # respect upstream’s wishes (and the version numbers inside the source tarball)
    # by packaging these releases as 3.3.3 with appropriate snapshot info.
    # https://github.com/lainsce/notejot/releases/tag/3.4.9
    #
    # Note that sometimes upstream don't update their version in meson.build
    # (https://github.com/lainsce/notejot/issues/236), always follow the version
    # from Fedora Rawhide.
    # https://github.com/lainsce/notejot/blob/3.4.9/meson.build#L1
    rev = "3.4.9";
    hash = "sha256-42k9CAnXAb7Ic580SIa95MDCkCWtso1F+0eD69HX8WI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    hicolor-icon-theme
    json-glib
    libadwaita
    libgee
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    homepage = "https://github.com/lainsce/notejot";
    description = "Stupidly-simple sticky notes applet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.github.lainsce.Notejot";
  };
}
