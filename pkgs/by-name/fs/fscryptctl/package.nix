{
  lib,
  stdenv,
  fetchFromGitHub,
  pandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fscryptctl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscryptctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5suEdSpX8alDkSnSnyiIjUmZq98eK0ZPVAtDKhOs65c=";
  };

  nativeBuildInputs = [ pandoc ];

  strictDeps = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Small C tool for Linux filesystem encryption";
    mainProgram = "fscryptctl";
    longDescription = ''
      fscryptctl is a low-level tool written in C that handles raw keys and
      manages policies for Linux filesystem encryption, specifically the
      "fscrypt" kernel interface which is supported by the ext4, f2fs, and
      UBIFS filesystems.
      fscryptctl is mainly intended for embedded systems which can't use the
      full-featured fscrypt tool, or for testing or experimenting with the
      kernel interface to Linux filesystem encryption. fscryptctl does not
      handle key generation, key stretching, key wrapping, or PAM integration.
      Most users should use the fscrypt tool instead, which supports these
      features and generally is much easier to use.
      As fscryptctl is intended for advanced users, you should read the kernel
      documentation for filesystem encryption before using fscryptctl.
    '';
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://github.com/google/fscryptctl/blob/master/NEWS.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
