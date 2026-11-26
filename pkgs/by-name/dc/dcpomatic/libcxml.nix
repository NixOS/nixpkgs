{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,

  wafHook,
  python3,
  gitMinimal,
  pkg-config,
  libxmlxx,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcxml";
  version = "0.17.18";

  src = fetchgit {
    url = "https://git.carlh.net/git/libcxml.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x3DJYs5/MJM7N22e5jSNR/OujyjVdOpQbXAnQlVIb9w=";
  };

  # for some reason the version is not set properly upstream
  postPatch = ''
    substituteInPlace wscript \
      --replace-fail \
        "this_version = subprocess.Popen(shlex.split('git tag -l --points-at HEAD'), stdout=subprocess.PIPE).communicate()[0].decode('UTF-8')" \
        "this_version = 'v${finalAttrs.version}'"
  '';

  nativeBuildInputs = [
    wafHook
    python3
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    libxmlxx
    boost
  ];

  passthru.updateScript =
    gitUpdater {
      rev-prefix = "v";
      attrPath = "dcpomatic.libcxml";
    }
    // {
      supportedFeatures = [ ];
    };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "libxml++ helper library";
    homepage = "https://git.carlh.net/cgit/libcxml";
    downloadPage = "https://git.carlh.net/cgit/libcxml";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
