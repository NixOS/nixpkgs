{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  eigen,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "fdip";
  version = "0-unstable-2025-07-18";

  src = fetchFromGitLab {
    domain = "gitlab.desy.de";
    owner = "thomas.white";
    repo = "fdip";
    rev = "631792e90ed2c3e226dce77bf97917305293ac66";
    hash = "sha256-7hFaPwLGzitwHwaaYIp2kVCUreo6ILwbQqYPAyyiDNU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ eigen ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fast Diffraction Image Processing library";
    homepage = "https://www.mdpi.com/2073-4352/14/2/164";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
}
