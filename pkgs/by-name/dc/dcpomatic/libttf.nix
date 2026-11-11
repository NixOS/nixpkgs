{
  lib,
  stdenv,
  fetchgit,

  wafHook,
  python3,
  gitMinimal,
  pkg-config,
  boost,
  fmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libttf";
  version = "0.0.7";

  src = fetchgit {
    url = "https://git.carlh.net/git/libttf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pLduKqcfCw8m4hZn8KsVa8rHESEPSQrvW4NCBcwXT5g=";
  };

  nativeBuildInputs = [
    wafHook
    python3
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    boost
    fmt
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Limited TTF manipulation library";
    homepage = "https://git.carlh.net/cgit/libttf";
    downloadPage = "https://git.carlh.net/cgit/libttf";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
