{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withNotification ? false,
  withYubikey ? false,
  withStrictCaller ? false,
  withAll ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-credential-keepassxc";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "git-credential-keepassxc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xhoi5S0cyHe1S7LWidhOcCKFUAKrz616vsmazYP92vM=";
  };

  cargoHash = "sha256-/LPyvFM394VwSZ3j0VOfXrs4zq5IMdRo02jzQIwkO7o=";

  buildFeatures =
    [ ]
    ++ lib.optional withNotification "notification"
    ++ lib.optional withYubikey "yubikey"
    ++ lib.optional withStrictCaller "strict-caller"
    ++ lib.optional withAll "all";

  meta = {
    description = "Helper that allows Git (and shell scripts) to use KeePassXC as credential store";
    longDescription = ''
      git-credential-keepassxc is a Git credential helper that allows Git
      (and shell scripts) to get/store logins from/to KeePassXC.
      It communicates with KeePassXC using keepassxc-protocol which is
      originally designed for browser extensions.
    '';
    homepage = "https://github.com/Frederick888/git-credential-keepassxc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "git-credential-keepassxc";
  };
})
