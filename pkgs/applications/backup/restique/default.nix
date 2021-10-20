{ lib
, mkDerivation
, fetchFromGitea
, cmake
, libsecret
, qtkeychain
, restic
}:

mkDerivation rec {
  pname = "restique";
  version = "unstable-2021-05-03";

  src = fetchFromGitea {
    domain = "git.srcbox.net";
    owner = "stefan";
    repo = "restique";
    rev = "f83ea63c2e2f2a41e845f54c7fe2c391a528a121";
    sha256 = "0j1qihv7hd90xkfm4ksv74q6m7cq781fbdnc3l4spcd7h2p8lh0z";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libsecret
    qtkeychain
  ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ restic ])
  ];

  meta = with lib; {
    description = "Restic GUI for Desktop/Laptop Backups";
    homepage = "https://git.srcbox.net/stefan/restique";
    license = with licenses; [ gpl3Plus cc-by-sa-40 cc0 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
