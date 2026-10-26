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
  pname = "chipsec";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    tag = finalAttrs.version;
    hash = "sha256-SynciTQU7kWzWu7wFN0oZ9mL7quUnPw6qc0FqUKd98g=";
  };

  postPatch = ''
    substituteInPlace chipsec/library/logger.py \
      --replace-fail "dir_path = os.path.dirname(os.path.realpath(__file__))" "" \
      --replace-fail "BASE_PATH = os.path.join(dir_path, os.pardir, os.pardir)" "" \
      --replace-fail 'self.LOG_PATH = os.path.join(BASE_PATH, "logs")' 'self.LOG_PATH = "/tmp/chipsec"'
  '';

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

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ brotli ];

  # Marker file preventing driver from being built
  preBuild = lib.optionalString (!withDriver) ''
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

  pythonImportsCheck = [ "chipsec" ];

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
    changelog = "https://github.com/chipsec/chipsec/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      johnazoidberg
      erdnaxe
      staslyakhov
    ];
    platforms = if withDriver then [ "x86_64-linux" ] else with lib.platforms; linux ++ darwin;
    mainProgram = "chipsec_main";
  };
})
