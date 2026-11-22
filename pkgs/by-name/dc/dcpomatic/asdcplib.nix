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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asdcplib";
  version = "1.0.11";

  src = fetchgit {
    url = "https://git.carlh.net/git/asdcplib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VkXDiNYPXU4eOgOfhZB3RMoSp1ujL2jMdAYwjdyIei0=";
  };

  # for some reason the version is not set properly upstream
  postPatch = ''
    substituteInPlace wscript \
      --replace-fail \
        "VERSION = open('VERSION').read().strip()" \
        "VERSION = '${finalAttrs.version}'"
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
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "asdcplib library for low-level DCP handling";
    homepage = "https://git.carlh.net/cgit/asdcplib";
    downloadPage = "https://git.carlh.net/cgit/asdcplib";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
