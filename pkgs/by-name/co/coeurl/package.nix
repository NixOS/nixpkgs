{
  lib,
  stdenv,
  fetchFromGitLab,
  ninja,
  pkg-config,
  meson,
  libevent,
  curl,
  spdlog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coeurl";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = "coeurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NGplM5c/dMGSQbhKeuPOTWL8KsqvMd/76YuwCxnqNNE=";
  };
  postPatch = ''
    substituteInPlace subprojects/curl.wrap --replace '[provides]' '[provide]'
  '';

  nativeBuildInputs = [
    ninja
    pkg-config
    meson
  ];

  buildInputs = [
    libevent
    curl
    spdlog
  ];

  meta = {
    description = "Simple async wrapper around CURL for C++";
    homepage = "https://nheko.im/nheko-reborn/coeurl";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
