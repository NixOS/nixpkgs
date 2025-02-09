{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gcc,
  rust-bindgen,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "firecracker";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = "firecracker";
    rev = "v${version}";
    hash = "sha256-kLQPAHbj8Q425Z5zdwofyHz+sd3bf7zGmcMjKn9yTKc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TnEPNTeeX1KP+9HLD/oGF0sZGcXDHpc1Q1wCWw3L6mU=";

  # For aws-lc-sys@0.22.0: use external bindgen.
  AWS_LC_SYS_EXTERNAL_BINDGEN = "true";

  # For aws-lc-sys@0.22.0: fix gcc error:
  # In function 'memcpy',
  #   inlined from 'OPENSSL_memcpy' at aws-lc/crypto/asn1/../internal.h
  #   inlined from 'aws_lc_0_22_0_i2c_ASN1_BIT_STRING' at aws-lc/crypto/asn1/a_bitstr.c
  # glibc/.../string_fortified.h: error: '__builtin_memcpy' specified bound exceeds maximum object size [-Werror=stringop-overflow=]
  postPatch = ''
    substituteInPlace $cargoDepsCopy/aws-lc-sys-*/aws-lc/crypto/asn1/a_bitstr.c \
      --replace-warn '(len > INT_MAX - 1)' '(len < 0 || len > INT_MAX - 1)'
  '';

  nativeBuildInputs = [
    cmake
    gcc
    rust-bindgen  # for aws-lc-sys@0.22.0
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [ "--package" "firecracker" "--package" "jailer" ];

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
    "--skip=resource_limits::tests::test_set_resource_limits"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    releaseDir="build/cargo_target/${stdenv.hostPlatform.rust.rustcTarget}/release"
    for bin in $(find $releaseDir -maxdepth 1 -type f -executable); do
      install -Dm555 -t $out/bin $bin
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage = "http://firecracker-microvm.io";
    changelog = "https://github.com/firecracker-microvm/firecracker/releases/tag/v${version}";
    mainProgram = "firecracker";
    license = licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [
      usertam
      thoughtpolice
      qjoly
      techknowlogick
    ];
  };
}
