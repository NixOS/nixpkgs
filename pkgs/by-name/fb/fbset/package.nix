{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbset";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "sudipm-mukherjee";
    repo = "fbset";
    rev = "debian/${finalAttrs.version}-33";
    hash = "sha256-nwWkQAA5+v5A8AmKg77mrSq2pXeSivxd0r7JyoBrs9A=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "DESTDIR=$(out)" ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Framebuffer device maintenance program";
    homepage = "https://github.com/sudipm-mukherjee/fbset";
    license = lib.licenses.gpl2Only;
    mainProgram = "fbset";
    maintainers = with lib.maintainers; [ baloo ];
    platforms = lib.platforms.linux;
  };
})
