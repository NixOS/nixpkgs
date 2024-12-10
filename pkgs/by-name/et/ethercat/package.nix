{
  autoreconfHook,
  cmake,
  lib,
  pkg-config,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ethercat";
  version = "1.6-alpha";

  src = fetchFromGitLab {
    owner = "etherlab.org";
    repo = "ethercat";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-kzyA6h0rZFEROLcFZoU+2fIQ/Y0NwtdPuliKDbwkHrE=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--enable-userlib=yes"
    "--enable-kernel=no"
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "IgH EtherCAT Master for Linux";
    homepage = "https://etherlab.org/ethercat";
    changelog = "https://gitlab.com/etherlab.org/ethercat/-/blob/${finalAttrs.version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "x86_64-linux" ];
  };
})
