{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-hlr";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-hlr";
    rev = finalAttrs.version;
    hash = "sha256-yi4sgcX8WOWz7qw/jGvVCtIYe867uBzLps8gdG6ziOA=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    sqlite
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Home Location Registr (HLR)";
    homepage = "https://osmocom.org/projects/osmo-hlr";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-hlr";
  };
})
