{ lib, stdenv, fetchFromGitHub, bash, ocaml, dune_3 }:

stdenv.mkDerivation {
  pname = "rescript-editor-analysis";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = "1.3.0";
    sha256 = "IL0sn7cpCHbSR19n6HvLyhp5aqit4EfO+EhK0lA9A1A=";
  };

  nativeBuildInputs = [ ocaml dune_3 ];

  postPatch = ''
    cd analysis
    substituteInPlace Makefile --replace "/bin/bash" "${bash}/bin/bash"
  '';

  installPhase = ''
    install -D -m0555 rescript-editor-analysis.exe $out/bin/rescript-editor-analysis.exe
  '';

  meta = with lib; {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = with maintainers; [ dlip jayesh-bhoot ];
    license = licenses.mit;
  };
}
