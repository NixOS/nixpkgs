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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-Fu0zQIryESRaTGzDlAaewX9Yo2nPEeUxmcb3yPJLuSI=";
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
