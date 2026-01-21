{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  boost,
  libusb1,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cc-tool";
  version = "0.27-unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "dashesy";
    repo = "cc-tool";
    rev = "0d84df329e343e2ea5a960c04a3d4478ee039aa0";
    hash = "sha256-3zZNzH+T/Wc3rn+ZmdpQ5U0Fs6ylT/QhX1pUUD8kPoE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost
    libusb1
  ];

  postPatch = ''
    substituteInPlace udev/90-cc-debugger.rules \
      --replace-fail 'MODE="0666"' 'MODE="0660", GROUP="plugdev", TAG+="uaccess"'
  '';

  configureFlags = [
    "--with-boost=${lib.getDev boost}"
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  postInstall = ''
    install -D udev/90-cc-debugger.rules $out/lib/udev/rules.d/90-cc-debugger.rules
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Command line tool for the Texas Instruments CC Debugger";
    mainProgram = "cc-tool";
    longDescription = ''
      cc-tool provides support for Texas Instruments CC Debugger
    '';
    homepage = "https://github.com/dashesy/cc-tool";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.CRTified ];
  };
}
