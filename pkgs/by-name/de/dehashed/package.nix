{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  python3Packages,
  ...
}:

python3Packages.buildPythonPackage rec {
  pname = "dehashed";
  version = "0-unstable-20-07-2024";
  format = "other";

  # This is a fork with the shebang
  src = fetchFromGitHub {
    owner = "akechishiro";
    repo = "dehashed";
    rev = "ad984ea960c533b6a74b077c3849b4fe3606e703";
    hash = "sha256-JphkugkjgsLzw56udWGwWEe99iZK/X5fW9lcknyqxQU=";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    certifi
    charset-normalizer
    idna
    fake-useragent
    requests
    soupsieve
    urllib3
  ];

  installPhase = ''
    install -Dm755 dehashed.py $out/bin/dehashed.py
  '';

  meta = with lib; {
    description = "Python script to query dehashed API for leaked password/hashes";
    mainProgram = "dehashed.py";
    homepage = "https://github.com/akechishiro/dehashed";
    changelog = "https://github.com/akechishiro/dehashed/${src.rev}";
    license = licenses.unfree; # no license in original package
    maintainers = with maintainers; [ akechishiro ];
  };
}
