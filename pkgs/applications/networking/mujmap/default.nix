{ lib
, fetchFromGitHub
, rustPlatform
, notmuch
}:

rustPlatform.buildRustPackage rec {
  pname = "mujmap";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G5CPH6CmQtw7pegBR6B/WBOZXUvFzEPBBvgqYEIF2OI=";
  };

  cargoSha256 = "sha256-nrLorxdJdQvCG8WhfsvHtWizrkzD38XqgeNyksKbvN4=";

  buildInputs = [ notmuch ];
  propagatedUserEnvPkgs = [ notmuch ];

  meta = with lib; {
    description = "Bridge for synchronizing email and tags between JMAP and notmuch";
    homepage = "https://github.com/elizagamedev/mujmap/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ elizagamedev ];
    mainProgram = "mujmap";
  };
}
