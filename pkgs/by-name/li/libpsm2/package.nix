{
  lib,
  stdenv,
  fetchFromGitHub,
  numactl,
  pkg-config,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpsm2";
  version = "12.0.1";

  preConfigure = ''
    export UDEVDIR=$out/etc/udev
    substituteInPlace ./Makefile --replace "udevrulesdir}" "prefix}/etc/udev";
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ numactl ];

  makeFlags = [
    # Disable blanket -Werror to avoid build failures
    # on fresh toolchains like gcc-11.
    "WERROR="
  ];

  doInstallCheck = true;

  installFlags = [
    "DESTDIR=$(out)"
    "UDEVDIR=/etc/udev"
    "LIBPSM2_COMPAT_CONF_DIR=/etc"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "PSM2_${finalAttrs.version}";
    sha256 = "sha256-MzocxY+X2a5rJvTo+gFU0U10YzzazR1IxzgEporJyhI=";
  };

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = {
    homepage = "https://github.com/intel/opa-psm2";
    description = "PSM2 library supports a number of fabric media and stacks";
    license = with lib.licenses; [
      gpl2Only
      bsd3
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.bzizou ];
    # uses __off64_t, srand48_r, lrand48_r, drand48_r
    broken = stdenv.hostPlatform.isMusl;
  };
})
