{
  autoreconfHook,
  lib,
  pkg-config,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ethercat";
  version = "1.6.9";

  src = fetchFromGitLab {
    owner = "etherlab.org";
    repo = "ethercat";
    tag = finalAttrs.version;
    hash = "sha256-Msx0i1SAwlSMD3+vjGRNe36Yx9qdUYokVekGytZptqk=";
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

  passthru = {
    kernelModule = import ./kernel-module.nix finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "IgH EtherCAT Master for Linux";
    homepage = "https://etherlab.org/ethercat";
    changelog = "https://gitlab.com/etherlab.org/ethercat/-/blob/${finalAttrs.version}/NEWS";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [
      ninelore
      stv0g
    ];
    platforms = [ "x86_64-linux" ];
  };
})
