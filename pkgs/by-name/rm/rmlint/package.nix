{
  lib,
  stdenv,
  cairo,
  elfutils,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtksourceview4,
  json-glib,
  makeWrapper,
  pango,
  pkg-config,
  python3,
  scons,
  util-linux,
  wrapGAppsHook3,
  withGui ? false,
}:

assert withGui -> !stdenv.hostPlatform.isDarwin;

stdenv.mkDerivation (finalAttrs: {
  pname = "rmlint";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U6D11BWKP5kK2UXhnD0hiflTTb7qKjSpJwYQt0U+i3Q=";
  };

  patches = [
    # pass through NIX_* environment variables to scons.
    ./scons-nix-env.patch
  ];

  nativeBuildInputs = [
    pkg-config
    python3.pkgs.sphinx
    scons
  ]
  ++ lib.optionals withGui [
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    python3.pkgs.build
    python3.pkgs.installer
    python3.pkgs.setuptools
  ];

  buildInputs = [
    glib
    json-glib
    util-linux
  ]
  ++ lib.optionals withGui [
    cairo
    gtksourceview4
    pango
    python3
    python3.pkgs.pygobject3
    python3.pkgs.colorlog
    python3.pkgs.parsedatetime
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
    elfutils
  ];

  # Otherwise the install would use upstream's default prefix /usr/local.
  prefixKey = "PREFIX=";

  sconsFlags =
    lib.optionals (!withGui) [ "--without-gui" ]
    ++ lib.optionals withGui [ "--allow-externally-managed" ];

  # in GUI mode, this shells out to itself, and tries to import python modules
  postInstall = lib.optionalString withGui ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin"
      --prefix PYTHONPATH : "$(toPythonPath $out)"
      --prefix PYTHONPATH : "$(toPythonPath ${python3.pkgs.pygobject3})"
      --prefix PYTHONPATH : "$(toPythonPath ${python3.pkgs.pycairo})"
      --prefix PYTHONPATH : "$(toPythonPath ${python3.pkgs.colorlog})"
      --prefix PYTHONPATH : "$(toPythonPath ${python3.pkgs.parsedatetime})"
    )
  '';

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = "https://rmlint.readthedocs.org";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      aaschmid
      koral
    ];
    mainProgram = "rmlint";
  };
})
