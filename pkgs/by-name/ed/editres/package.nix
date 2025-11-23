{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapWithXFileSearchPathHook,
  libx11,
  libxaw,
  libxkbfile,
  libxmu,
  libxres,
  libxt,
  util-macros,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "editres";
  version = "1.0.9";

  strictDeps = true;

  src = fetchurl {
    url = "mirror://xorg/individual/app/editres-${finalAttrs.version}.tar.xz";
    hash = "sha256-zfw/em8OzqQXr3hbH0ZGnZwho1Q6dlSAowkP1l49s8Y=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxaw
    libxkbfile
    libxmu
    libxres
    libxt
    util-macros
    xorgproto
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Dynamic resource editor for X Toolkit applications";
    longDescription = ''
      Editres is a tool that allows users and application developers to view the full widget
      hierarchy of any Xt Toolkit application that speaks the Editres protocol. In addition, editres
      will help the user construct resource specifications, allow the user to apply the resource
      to the application and view the results dynamically. Once the user is happy with a resource
      specification editres will append the resource string to the user's X Resources file.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/editres";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "editres";
    platforms = lib.platforms.linux;
  };
})
