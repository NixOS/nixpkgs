{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, DiskArbitration
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "git-credential-keepassxc";
    rev = "v${version}";
    hash = "sha256-zVE3RQlh0SEV4iavz40YhR+MP31oLCvG54H8gqXwL/k=";
  };

  cargoHash = "sha256-H75SGbT//02I+umttnPM5BwtFkDVNxEYLf84oULEuEk=";

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation ];

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
  };
}
