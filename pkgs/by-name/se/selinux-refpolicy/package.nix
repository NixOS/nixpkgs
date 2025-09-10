{
  lib,
  stdenv,
  fetchFromGitHub,
  gnum4,
  python3,
  getopt,
  checkpolicy,
  policycoreutils,
  semodule-utils,
  policyVersion ? null,
  moduleVersion ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "selinux-refpolicy";
  version = "2.20250213";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = "refpolicy";
    tag = "RELEASE_${lib.versions.major finalAttrs.version}_${lib.versions.minor finalAttrs.version}";
    hash = "sha256-VsQRqigGwSVJ52uqFj1L2xzQqbWwQ/YaFI5Rsn/HbP8=";
  };

  nativeBuildInputs = [
    gnum4
    python3
    getopt
  ];

  configurePhase = ''
    runHook preConfigure
    make conf ''${makeFlags[@]}
    runHook postConfigure
  '';

  makeFlags = [
    "CHECKPOLICY=${lib.getExe checkpolicy}"
    "CHECKMODULE=${lib.getExe' checkpolicy "checkmodule"}"
    "SEMODULE=${lib.getExe' policycoreutils "semodule"}"
    "SEMOD_PKG=${lib.getExe' semodule-utils "semodule_package"}"
    "SEMOD_LNK=${lib.getExe' semodule-utils "semodule_link"}"
    "SEMOD_EXP=${lib.getExe' semodule-utils "semodule_expand"}"
    "DESTDIR=${placeholder "out"}"
    "prefix=${placeholder "out"}"
    "DISTRO=nixos"
    "SYSTEMD=y"
    "UBAC=y"
  ]
  ++ lib.optional (policyVersion != null) "OUTPUT_POLICY=${toString policyVersion}"
  ++ lib.optional (moduleVersion != null) "OUTPUT_MODULE=${toString moduleVersion}";

  installTargets = "all install install-headers install-docs";

  meta = {
    description = "SELinux Reference Policy v2";
    homepage = "http://userspace.selinuxproject.org";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.gpl2Only;
  };
})
