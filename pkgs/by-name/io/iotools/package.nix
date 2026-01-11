{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iotools";
  version = "unstable-2017-12-11";

  src = fetchFromGitHub {
    owner = "adurbin";
    repo = "iotools";
    rev = "18949fdc4dedb1da3f51ee83a582b112fb9f2c71";
    hash = "sha256-tlGXJn3n27mQDupMIVYDd86YaWazVwel/qs0QqCy1W8=";
  };

  patches = [ ./001-fix-werror-in-sprintf.patch ];

  makeFlags = [
    "DEBUG=0"
    "STATIC=0"
  ];

  installPhase = ''
    install -Dm755 iotools -t $out/bin
  '';

  meta = {
    description = "Set of simple command line tools which allow access to
      hardware device registers";
    longDescription = ''
      Provides a set of simple command line tools which allow access to
      hardware device registers. Supported register interfaces include PCI,
      IO, memory mapped IO, SMBus, CPUID, and MSR. Also included are some
      utilities which allow for simple arithmetic, logical, and other
      operations.
    '';
    homepage = "https://github.com/adurbin/iotools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "iotools";
  };
})
