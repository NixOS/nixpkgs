{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt-st";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "iustin";
    repo = "mt-st";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AptSSnCKpQOF7kRkGbKyHgwMDVn3c4kgNBOF2g++06Y=";
  };

  installFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
    "COMPLETIONINSTALLDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    description = "Magnetic Tape control tools for Linux";
    longDescription = ''
      Fork of the standard "mt" tool with additional Linux-specific IOCTLs.
    '';
    homepage = "https://github.com/iustin/mt-st";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.linux;
  };
})
