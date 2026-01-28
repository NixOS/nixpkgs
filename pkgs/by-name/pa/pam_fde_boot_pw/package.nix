{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  pam,
  keyutils,
}:

stdenv.mkDerivation {
  pname = "pam_fde_boot_pw";
  version = "0-unstable-2025-02-14";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "pam_fde_boot_pw";
    rev = "49bf498fd8d13f73e4a24221818a8a5d2af20088";
    hash = "sha256-dS9ufryg3xfxgUzJKDgrvMZP2qaYH+WJQFw1ogl1isc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    pam
    keyutils
  ];

  mesonFlags = [
    (lib.mesonOption "pam-mod-dir" "${placeholder "out"}/lib/security")
  ];

  meta = {
    description = "PAM module for leveraging disk encryption password in the PAM session";
    longDescription = ''
      pam_fde_boot_pw transfers a password from the kernel keyring (for example,
      the passphrase used to unlock an encrypted disk) into the PAM session.
      This enables user-space keyrings, such as gnome-keyring, to be
      automatically unlocked.
    '';
    homepage = "https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ivanbrennan ];
  };
}
