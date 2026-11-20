{
  lib,
  stdenv,
  fetchgit,

  wafHook,
  python3,
  gitMinimal,
  pkg-config,
  openssl,
  libxmlxx,
  libcxml,
  xmlsec,
  imagemagick,
  libsndfile,
  openjpeg,
  boost,
  xercesc,
  ffmpeg-headless,
  fmt,
  fast-float,
  libtool,
  libharu,
  asdcplib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdcp";
  version = "1.10.63";

  src = fetchgit {
    url = "https://git.carlh.net/git/libdcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nT9wSOY/OPNRxpjnp+wblx7Jbx/S0uP7lL68zBK4NFk=";
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
    libxmlxx
    libcxml
    xmlsec
    imagemagick
    libsndfile
    openjpeg
    asdcplib
    xercesc
    boost
    ffmpeg-headless
    fmt
    fast-float
    libtool
    libharu
  ];

  propagatedBuildInputs = [
    asdcplib
  ];

  __structuredAttrs = true;

  meta = {
    description = "DCP handling library";
    homepage = "https://git.carlh.net/cgit/libdcp";
    downloadPage = "https://git.carlh.net/cgit/libdcp";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
