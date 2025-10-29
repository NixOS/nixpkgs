{
  lib,
  stdenv,
  fetchFromGitLab,
  guile,
  libgit2,
  scheme-bytestructures,
  autoreconfHook,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-git";
  version = "0.10.0";

  src = fetchFromGitLab {
    owner = "guile-git";
    repo = "guile-git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ihKpEnng6Uemrguecbd25vElEhIu2Efb86aM8679TAc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libgit2
    scheme-bytestructures
  ];
  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  enableParallelBuilding = true;

  # Skipping proxy tests since it requires network access.
  postConfigure = ''
    sed -i -e '94i (test-skip 1)' ./tests/proxy.scm
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Bindings to Libgit2 for GNU Guile";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = guile.meta.platforms;
  };
})
