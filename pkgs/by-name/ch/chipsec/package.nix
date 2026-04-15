{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel ? null,
  elfutils,
  nasm,
  python3,
  withDriver ? false,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;

  pname = "chipsec";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    tag = finalAttrs.version;
    hash = "sha256-SrQIEcRJHabrFRV50UJKnGmtq5kDpVKqbdq0W2+0Dqc=";
  };

  patches = [
    ./patches/log-path.diff
    ./patches/namespace_packages.diff
  ];

  env = lib.optionalAttrs withDriver {
    KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  };

  nativeBuildInputs = [
    nasm
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
    elfutils
  ]
  ++ lib.optionals withDriver kernel.moduleBuildDependencies;

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    brotli
  ];

  # Marker file preventing driver from being built
  preBuild = lib.optionals (!withDriver) ''
    touch README.NO_KERNEL_DRIVER
  '';

  nativeCheckInputs = with python3.pkgs; [
    distro
    pytestCheckHook
  ];

  # Allow the kernel module to be loaded manually
  postInstall = lib.optionalString withDriver ''
    pushd $out/${python3.pkgs.python.sitePackages}/chipsec/helper/linux/
      xz -k chipsec.ko
      install -Dm444 chipsec.ko.xz $out/lib/modules/${kernel.modDirVersion}/chipsec.ko.xz
      rm chipsec.ko.xz
    popd
  '';

  pythonImportsCheck = [
    "chipsec"
  ];

  meta = {
    description = "Platform Security Assessment Framework";
    longDescription = ''
      CHIPSEC is a framework for analyzing the security of PC platforms
      including hardware, system firmware (BIOS/UEFI), and platform components.
      It includes a security test suite, tools for accessing various low level
      interfaces, and forensic capabilities. It can be run on Windows, Linux,
      Mac OS X and UEFI shell.
    '';
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/chipsec/chipsec";
    maintainers = with lib.maintainers; [
      johnazoidberg
      erdnaxe
      staslyakhov
    ];
    platforms = if withDriver then [ "x86_64-linux" ] else with lib.platforms; linux ++ darwin;
    mainProgram = "chipsec_main";
  };
})
