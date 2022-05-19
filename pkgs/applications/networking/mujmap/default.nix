{ lib
, fetchFromGitHub
, rustPlatform
, notmuch
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mujmap";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O5CbLgs+MkATPtess0gocgPB9kwD8FMR/urwm6jo2rA=";
  };

  cargoSha256 = "sha256-nOZ+HnzXhVp+tLrNMZO1NmZIhIqlWz0fRMbHVIQkOxI=";

  buildInputs = [
    notmuch
  ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Bridge for synchronizing email and tags between JMAP and notmuch";
    homepage = "https://github.com/elizagamedev/mujmap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ elizagamedev ];
    mainProgram = "mujmap";
  };
}
