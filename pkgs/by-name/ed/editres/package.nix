{
  lib,
  stdenv,
<<<<<<< HEAD
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
=======
  fetchurl,
  pkg-config,
  libXt,
  libXaw,
  libXres,
  utilmacros,
}:

stdenv.mkDerivation rec {
  pname = "editres";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/editres-${version}.tar.gz";
    sha256 = "sha256-LVbWB3vHZ6+n4DD+ssNy/mvok/7EApoj9FodVZ/YRq4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libXt
    libXaw
    libXres
    utilmacros
  ];

  configureFlags = [ "--with-appdefaultdir=$(out)/share/X11/app-defaults/editres" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://cgit.freedesktop.org/xorg/app/editres/";
    description = "Dynamic resource editor for X Toolkit applications";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "editres";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
