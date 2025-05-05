{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gdk-pixbuf-xlib,
  gettext,
  gtk2-x11,
  libICE,
  libSM,
  libxcrypt,
  libXinerama,
  libXrandr,
  libXtst,
  librep,
  makeWrapper,
  pango,
  pkg-config,
  rep-gtk,
  texinfo,
  which,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sawfish";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "SawfishWM";
    repo = "sawfish";
    tag = "sawfish-${finalAttrs.version}";
    hash = "sha256-4hxws3afDN9RjO9JCEjEgG4/g6bSycrmiJzRoyNnl3s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    librep
    makeWrapper
    pkg-config
    texinfo
    which
  ];

  buildInputs = [
    gdk-pixbuf-xlib
    gtk2-x11
    libICE
    libSM
    libxcrypt
    libXinerama
    libXrandr
    libXtst
    librep
    pango
    rep-gtk
  ];

  postPatch = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  postInstall = ''
    for file in $out/lib/sawfish/sawfish-menu \
             $out/bin/sawfish-about \
             $out/bin/sawfish-client \
             $out/bin/sawfish-config \
             $out/bin/sawfish; do
      wrapProgram $file \
        --prefix REP_DL_LOAD_PATH : "$out/lib/rep" \
        --set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  meta = {
    homepage = "http://sawfish.tuxfamily.org/";
    description = "Extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting
      language. Its policy is very minimal compared to most window managers. Its
      aim is simply to manage windows in the most flexible and attractive manner
      possible. All high-level WM functions are implemented in Lisp for future
      extensibility or redefinition.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
    mainProgram = "sawfish";
  };
})
