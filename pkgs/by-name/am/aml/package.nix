{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "aml";
    tag = "v${version}";
    sha256 = "sha256-10gm6YphZrpLShj3NUj/AG24dSVLZAZbbnXr7GiF4DI=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  meta = {
    description = "Another main loop";
    inherit (src.meta) homepage;
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
