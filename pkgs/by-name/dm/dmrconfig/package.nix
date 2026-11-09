{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  fetchpatch,
  libusb1,
  systemd,
  udevCheckHook,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "dmrconfig";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "OpenRTX";
    repo = "dmrconfig";
    tag = finalAttrs.version;
    hash = "sha256-S4WPcVOr47fP6jqV8MYEcvV56rncDVQ4EiaR88vpkeM=";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/OpenRTX/dmrconfig/commit/1a6901488db26262a6b69f80b0e795864e9e8d0a.patch";
      hash = "sha256-whxo4KeBFXrWLRZS4heeWzr8HpIyxFBEu1ohVZIP/Q4=";
    })
  ];

  buildInputs = [
    libusb1
    systemd
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ udevCheckHook ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig
  '';

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "GITCOUNT=0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/udev/rules.d
    make install
    install 99-dmr.rules $out/lib/udev/rules.d/99-dmr.rules

    runHook postInstall
  '';

  meta = {
    description = "Configuration utility for DMR radios";
    longDescription = ''
      DMRconfig is a utility for programming digital radios via USB programming cable.
    '';
    homepage = "https://github.com/OpenRTX/dmrconfig";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "dmrconfig";
  };
})
