{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  boost,
  libusb1,
  pkg-config,
<<<<<<< HEAD
  unstableGitUpdater,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "cc-tool";
<<<<<<< HEAD
  version = "0.27-unstable-2025-10-17";
=======
  version = "unstable-2020-05-19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dashesy";
    repo = "cc-tool";
<<<<<<< HEAD
    rev = "0d84df329e343e2ea5a960c04a3d4478ee039aa0";
    hash = "sha256-3zZNzH+T/Wc3rn+ZmdpQ5U0Fs6ylT/QhX1pUUD8kPoE=";
=======
    rev = "19e707eafaaddee8b996ad27a9f3e1aafcb900d2";
    hash = "sha256:1f78j498fdd36xbci57jkgh25gq14g3b6xmp76imdpar0jkpyljv";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      --replace-fail 'MODE="0666"' 'MODE="0660", GROUP="plugdev", TAG+="uaccess"'
  '';

  configureFlags = [
    "--with-boost=${lib.getDev boost}"
  ];

  enableParallelBuilding = true;

=======
      --replace 'MODE="0666"' 'MODE="0660", GROUP="plugdev", TAG+="uaccess"'
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  postInstall = ''
    install -D udev/90-cc-debugger.rules $out/lib/udev/rules.d/90-cc-debugger.rules
  '';

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line tool for the Texas Instruments CC Debugger";
    mainProgram = "cc-tool";
    longDescription = ''
      cc-tool provides support for Texas Instruments CC Debugger
    '';
    homepage = "https://github.com/dashesy/cc-tool";
<<<<<<< HEAD
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.CRTified ];
=======
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.CRTified ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
