{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice-glue";
    rev = version;
    hash = "sha256-cUcJARbZV9Yaqd9TP3NVmF9p8Pjz88a3GmAh4c4sEHo=";
  };

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
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

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
