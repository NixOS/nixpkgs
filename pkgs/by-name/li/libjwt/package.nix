{
  stdenv,
  lib,
  check,
  cmake,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  jansson,
  openssl,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjwt";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8478rW9ovFS0kSo1Zk/nobNgOvEOtAc/zbnw3ciEwc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail /bin/bash "${runtimeShell}"
  '';

  buildInputs = [
    jansson
    openssl
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = true;

  checkInputs = [
    check
  ];

  meta = {
    changelog = "https://github.com/benmcollins/libjwt/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/benmcollins/libjwt";
    description = "JWT C Library";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pnotequalnp ];
    platforms = lib.platforms.all;
  };
})
