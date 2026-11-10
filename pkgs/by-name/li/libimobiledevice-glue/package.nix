{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libimobiledevice-glue";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice-glue";
    rev = finalAttrs.version;
    hash = "sha256-3MEATpgk8OlRvPJRFcfJxkVAtB1Nszokp9u68/SME6c=";
  };

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  outputs = [
    "out"
    "dev"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
