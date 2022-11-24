{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, DiskArbitration
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "git-credential-keepassxc";
    rev = "v${version}";
    hash = "sha256-ZpysJ+xs3IenqAdoswG0OkzxzuNPSKkqlutGxn4VRw8=";
  };

  cargoHash = "sha256-IPsMlVfgwoFEQlXmW4gnt16WNF5W6akobUVct/iF42E=";

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
