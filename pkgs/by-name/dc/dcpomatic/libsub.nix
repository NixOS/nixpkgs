{
  lib,
  stdenv,
  fetchgit,

  wafHook,
  python3,
  gitMinimal,
  pkg-config,
  openssl,
  boost,
  fmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsub";
  version = "1.6.62";

  src = fetchgit {
    url = "https://git.carlh.net/git/libsub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NSCg+YnxUPII16K1SGozBRYorm0UVGTGozJOhLti4kc=";
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
    openssl
    boost
    fmt
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Subtitle handling library";
    homepage = "https://git.carlh.net/cgit/libsub";
    downloadPage = "https://git.carlh.net/cgit/libsub";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
