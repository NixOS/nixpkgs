{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  libfontenc,
  freetype,
  xorgproto,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fonttosfnt";
  version = "1.2.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "fonttosfnt";
    tag = "fonttosfnt-${finalAttrs.version}";
    hash = "sha256-W516e6ChCyvyjW4AT5DKzg12s+up0fO5UMDedAcO68o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
  ];

  buildInputs = [
    libfontenc
    freetype
    xorgproto
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=fonttosfnt-(.*)" ]; };

  meta = {
    description = "Wraps a set of bdf or pcf bitmap fonts in a sfnt (TrueType or OpenType) wrapper";
    homepage = "https://gitlab.freedesktop.org/xorg/app/fonttosfnt";
    license = lib.licenses.mit;
    mainProgram = "fonttosfnt";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    # something about missing `gzgetc` `gzopen` and `gzclose`
    # works on pkgsMusl so definitely a static problem
    broken = stdenv.hostPlatform.isStatic;
  };
})
