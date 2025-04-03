{
  fetchFromGitLab,
  gi-docgen,
  gobject-introspection,
  lcms2,
  lib,
  meson,
  ninja,
  pkg-config,
  stdenv,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babl";
  version = "0.1.112";

  outputs = [
    "dev"
    "devdoc"
    "out"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "babl";
    tag = "BABL_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-Xlsecb8MB3FnIaXgbN1/l3FPqs8xxu6q7Qudo3fjSxI=";
  };

  postUnpack = ''
    cp source/git-version.h.in source/git-version.h
    substituteInPlace source/git-version.h --replace-fail "@BABL_GIT_VERSION@" "${finalAttrs.src.tag}"
  '';

  patches = [
    # Allow overriding path to dev output that will be hardcoded e.g. in pkg-config file.
    ./dev-prefix.patch
  ];

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    lcms2
  ];

  mesonFlags =
    [
      "-Dprefix-dev=${placeholder "dev"}"
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      # Docs are opt-out in native but opt-in in cross builds.
      "-Dwith-docs=true"
      "-Denable-gir=true"
    ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/babl/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Image pixel format conversion library";
    homepage = "https://gegl.org/babl/";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "babl";
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
})
