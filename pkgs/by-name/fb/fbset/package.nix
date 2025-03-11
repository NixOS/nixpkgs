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

  installFlags = [ "DESTDIR=$(out)" ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "framebuffer device maintenance program";
    # NOTE: the website of the original author disappeared, the only remaining
    # repository is maintained by the debian maintainer of the package at
    # https://github.com/sudipm-mukherjee/fbset
    homepage = "http://users.telenet.be/geertu/Linux/fbdev/";
    license = licenses.gpl2Only;
    mainProgram = "fbset";
    maintainers = with maintainers; [ baloo ];
    platforms = platforms.linux;
  };
})
