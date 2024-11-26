{
  lib,
  gccStdenv,
  fetchFromGitHub,
}:

gccStdenv.mkDerivation rec {
  pname = "muscle";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "rcedgar";
    repo = pname;
    rev = version;
    hash = "sha256-NpnJziZXga/T5OavUt3nQ5np8kJ9CFcSmwyg4m6IJsk=";
  };

  sourceRoot = "${src.name}/src";

  patches = [
    ./muscle-darwin-g++.patch
  ];

  installPhase =
    let
      target = if gccStdenv.hostPlatform.isDarwin then "Darwin" else "Linux";
    in
    ''
      install -m755 -D ${target}/muscle $out/bin/muscle
    '';

  meta = with lib; {
    description = "Multiple sequence alignment with top benchmark scores scalable to thousands of sequences";
    mainProgram = "muscle";
    license = licenses.gpl3Plus;
    homepage = "https://www.drive5.com/muscle/";
    maintainers = with maintainers; [
      unode
      thyol
    ];
  };
}
