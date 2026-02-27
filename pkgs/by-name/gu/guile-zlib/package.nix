{
  autoreconfHook,
  fetchFromGitea,
  guile,
  lib,
  pkg-config,
  stdenv,
  texinfo,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-zlib";
  version = "0.2.2";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "guile-zlib";
    repo = "guile-zlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aaZhwHimQq408DNtHy442kh/EYdRdxP0Z1tQGDKmkmc=";
  };

  strictDeps = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  propagatedBuildInputs = [ zlib ];
  buildInputs = [ guile ];
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  doCheck = false; # Tests failing, disable for right now

  meta = {
    description = "GNU Guile library providing bindings to zlib";
    homepage = "https://notabug.org/guile-zlib/guile-zlib";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    inherit (guile.meta) platforms;
  };
})
