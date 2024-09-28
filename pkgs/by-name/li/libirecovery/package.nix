{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libimobiledevice-glue,
  libusb1,
  readline,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libirecovery";
  version = "1.2.0-unstable-2024-09-24";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libirecovery";
    rev = "d55c5f8742564a87f497a33324d12c873efa60c6";
    hash = "sha256-YRFuI5UmRH4bC477+J+RNy2j36C6YznYzAsuPTHZC9c=";
  };

  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libimobiledevice-glue
    libusb1
    readline
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  # Packager note: Not clear whether this needs a NixOS configuration,
  # as only the `idevicerestore` binary was tested so far (which worked
  # without further configuration).
  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    ''--with-udevrule="OWNER=\"root\", GROUP=\"myusergroup\", MODE=\"0660\""''
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libirecovery";
    description = "Library and utility to talk to iBoot/iBSS via USB on Mac OS X, Windows, and Linux";
    longDescription = ''
      libirecovery is a cross-platform library which implements communication to
      iBoot/iBSS found on Apple's iOS devices via USB. A command-line utility is also
      provided.
    '';
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      frontear
      nh2
    ];
    mainProgram = "irecovery";
  };
})
