{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, DiskArbitration
, Foundation
, withNotification ? false
, withYubikey ? false
, withStrictCaller ? false
, withAll ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "git-credential-keepassxc";
    rev = "v${version}";
    hash = "sha256-AvnnzLiDQEdfAHPns8ufhdiPPn9d23AnI8Aq2DQS+To=";
  };

  cargoHash = "sha256-c2YucWs0UzyWDKWS5KebT3ps+XvWzlI0+ziJ8JX6oiQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation ];

  buildFeatures = []
    ++ lib.optional withNotification "notification"
    ++ lib.optional withYubikey "yubikey"
    ++ lib.optional withStrictCaller "strict-caller"
    ++ lib.optional withAll "all";

  meta = with lib; {
    description = "Helper that allows Git (and shell scripts) to use KeePassXC as credential store";
    longDescription = ''
      git-credential-keepassxc is a Git credential helper that allows Git
      (and shell scripts) to get/store logins from/to KeePassXC.
      It communicates with KeePassXC using keepassxc-protocol which is
      originally designed for browser extensions.
    '';
    homepage = "https://github.com/Frederick888/git-credential-keepassxc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "git-credential-keepassxc";
  };
}
