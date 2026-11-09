{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-lc,
  libseccomp,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firecracker";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = "firecracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JA9NjEYOVegrRJqOtyMqB/hrkhRggg3CpcDyXLYlfq0=";
  };

  cargoHash = "sha256-H0yQFvaQvmPZsSebO3LO/69n4re55s0BweJHX+FRN80=";

  # For cpu-template-helper: patch build.rs to use stdenv's cc which ensures the correct compiler is used across all stdenv's.
  #
  # For seccompiler: fix hardcoded /usr/local/lib path to libseccomp.lib, this makes sure rustc can find seccomp across stdenv's(including pkgsStatic).
  postPatch = ''
    substituteInPlace src/cpu-template-helper/build.rs \
      --replace-fail '"gcc"' "\"$CC\""

    substituteInPlace src/seccompiler/build.rs \
      --replace-fail "/usr/local/lib" "${lib.getLib libseccomp}/lib"
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook # for userfaultfd-sys
  ];

  buildInputs = [ aws-lc ];

  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [
    "--package"
    "firecracker"
    "--package"
    "jailer"
  ];

  checkFlags = [
    # basic tests to skip in sandbox
    "--skip=fingerprint::dump::tests::test_read_valid_sysfs_file"
    "--skip=template::dump::tests::test_dump"
    "--skip=tests::test_filter_apply"
    "--skip=tests::test_fingerprint_dump_command"
    "--skip=tests::test_template_dump_command"
    "--skip=tests::test_template_verify_command"
    "--skip=utils::tests::test_build_microvm"
    # more tests to skip in sandbox
    "--skip=env::tests::test_copy_cache_info"
    "--skip=env::tests::test_dup2"
    "--skip=env::tests::test_mknod_and_own_dev"
    "--skip=env::tests::test_setup_jailed_folder"
    "--skip=env::tests::test_userfaultfd_dev"
    "--skip=env::tests::test_copy_exec_to_chroot"
    "--skip=resource_limits::tests::test_set_resource_limits"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    releaseDir="build/cargo_target/${stdenv.hostPlatform.rust.rustcTarget}/release"
    for bin in $(find $releaseDir -maxdepth 1 -type f -executable); do
      install -Dm555 -t $out/bin $bin
    done

    runHook postInstall
  '';

  meta = {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage = "http://firecracker-microvm.io";
    changelog = "https://github.com/firecracker-microvm/firecracker/releases/tag/v${finalAttrs.version}";
    mainProgram = "firecracker";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      iamanaws
      usertam
      thoughtpolice
      qjoly
      techknowlogick
    ];
  };
})
