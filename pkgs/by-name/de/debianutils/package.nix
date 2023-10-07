{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, perl
, po4a
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "debianutils";
  version = "5.13";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "debianutils";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-h6swRil0sldRaZT7/LMEmV6Ah3zoppiHeGO3xTJlrac=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    po4a
  ];

  strictDeps = true;

  outputs = [ "out" "man" ];

  meta = {
    homepage = "https://packages.debian.org/sid/debianutils";
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
      This package provides a number of small utilities which are used primarily
      by the installation scripts of Debian packages, although you may use them
      directly.

      The specific utilities included are: add-shell installkernel ischroot
      remove-shell run-parts savelog tempfile which
    '';
    license = with lib.licenses; [ gpl2Plus publicDomain smail ];
    mainProgram = "ischroot";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
