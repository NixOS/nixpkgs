{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
  meson,
  ninja,
}:

stdenvNoCC.mkDerivation {
  pname = "libsmarter";
  version = "0-unstable-2026-07-18";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "libsmarter";
    rev = "810746abbf03db3d95e49754a137d4417e216832";
    sha256 = "sha256-2PN6qc62n/311WXx7iMoDeQgG2IO5CATJc6choox4l0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "More powerful reference-counting smart pointers for C++";
    homepage = "https://github.com/managarm/libsmarter";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
