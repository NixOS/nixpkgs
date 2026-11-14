{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libcups3,
  pappl2,
}:

# As of June 22 2026, OpenPrinting/cups-sharing contains only the autotools
# skeleton (configure.ac, Makedefs.in, top-level Makefile) there is
# no daemon, commands, or man directory
# Upstream's own language breakdown is M4/Shell/Makefile only; no C sources
# have landed. configure+make below succeed against what exists today, but
# produce no actual "Sharing Server" there is nothing yet to build one
# from. This is a scaffold to extend once upstream lands real source, not a
# usable package.

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-sharing";
  version = "unstable-2026-06-18";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-sharing";
    rev = "87d744e666841e42700d037858c841dda25aa378";
    hash = "sha256-uH++IOG9zfc1oGUYB8LacR5TJlR0r6NX9PtFH2gQZS8=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libcups3
    pappl2
  ];

  strictDeps = true;

  # Intercept the infinite recursion loop in the upstream skeleton Makefile
  dontBuild = true;

  # Create a dummy binary/scaffold output so that systemd and the environment path declarations do not crash on a missing $out/bin binpath
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/cups-sharing
    echo "#!/bin/sh" > $out/bin/cups-sharingd
    echo "echo 'cups-sharing scaffold wrapper'" >> $out/bin/cups-sharingd
    chmod +x $out/bin/cups-sharingd

    runHook postInstall
  '';
  configureFlags = [
    "--prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = false;

  meta = {
    description = "Sharing server for CUPS 3.0 upstream currently ships only the build skeleton, no daemon source (alpha)";
    homepage = "https://github.com/OpenPrinting/cups-sharing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.linux;
    broken = true;
  };
})
