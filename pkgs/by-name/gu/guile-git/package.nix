{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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

  patches = [
    # remove > 0.10.0
    (fetchpatch {
      name = "catch-git-error-guile";
      url = "https://gitlab.com/guile-git/guile-git/-/commit/9c76c6b31e217c470c8576172b123be9c373dc9b.diff";
      hash = "sha256-H0s7Ebl+HNL8Zak58kJmFETWZJcNq+Z5gTGRqU9gj58=";
    })
    # remove > 0.10.0
    (fetchpatch {
      name = "test-typo";
      url = "https://gitlab.com/guile-git/guile-git/-/commit/4451c0808fbdf8cd13d486a18b03881f998f6e88.diff";
      hash = "sha256-K2f67WXUBLI/09eF8Xg3JMX7gkISFTZK3yHu0VDVQ4E=";
    })
  ];

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
