{ lib, stdenvNoCC, fetchFromGitHub, python3 }:

stdenvNoCC.mkDerivation rec {
  pname = "shellnoob";
  version = "unstable-2022-03-16";

  src = fetchFromGitHub {
    owner = "reyammer";
    repo = pname;
    rev = "72cf49804d8ea3de1faa7fae5794449301987bff";
    sha256 = "xF9OTFFe8godW4+z9MFaFEkjE9FB42bKWwdl9xRcmEo=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 shellnoob.py $out/bin/snoob

    runHook postInstall
  '';

  meta = with lib; {
    description = "Shellcode writing toolkit";
    homepage = "https://github.com/reyammer/shellnoob";
    mainProgram = "snoob";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
