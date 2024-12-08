{ lib
, mkDerivation
, fetchFromGitea
, cmake
, libsecret
, qtkeychain
, qttools
, restic
}:

mkDerivation rec {
  pname = "restique";
  version = "unstable-2022-11-29";

  src = fetchFromGitea {
    domain = "git.srcbox.net";
    owner = "stefan";
    repo = "restique";
    rev = "906b0b1726c26988c910baea9665f540c37c99c4";
    hash = "sha256-EYoADtYX+gm8T3/3gxTtdFOFGJf2rXryiTu8NIO0Ez4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libsecret
    qtkeychain
    qttools
  ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ restic ])
  ];

  meta = with lib; {
    description = "Restic GUI for Desktop/Laptop Backups";
    homepage = "https://git.srcbox.net/stefan/restique";
    license = with licenses; [ gpl3Plus cc-by-sa-40 cc0 ];
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "restique";
  };
}
