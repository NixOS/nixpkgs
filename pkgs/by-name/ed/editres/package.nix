{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  wrapWithXFileSearchPathHook,
  libx11,
  libxaw,
  libxkbfile,
  libxmu,
  libxres,
  libxt,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "editres";
  version = "1.0.9";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "editres";
    tag = "editres-${finalAttrs.version}";
    hash = "sha256-fdp6j8zS8mtzHpG9js9c8iIt1vsKsqGG9MdkpLh8UB0=";
  };

  strictDeps = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxaw
    libxkbfile
    libxmu
    libxres
    libxt
    xorgproto
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=editres-(.*)" ]; };

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
