{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libzip,
  boost,
  wt,
  libconfig,
  pkg-config,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fileshelter";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "fileshelter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wh2M9bWIgQ3b8q4TVAq88LAomjiwNDND1b2FRsiYZng=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libzip
    boost
    wt
    libconfig
    libarchive
  ];

  env.NIX_LDFLAGS = "-lpthread";

  postInstall = ''
    ln -s ${wt}/share/Wt/resources $out/share/fileshelter/docroot/resources
  '';

  meta = {
    homepage = "https://github.com/epoupon/fileshelter";
    description = "One-click file sharing web application";
    mainProgram = "fileshelter";
    maintainers = with lib.maintainers; [ kamadorueda ];
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
})
