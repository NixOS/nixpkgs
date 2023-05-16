{ lib, stdenv, python3, fetchFromGitHub, exiftool, makeWrapper }:
let
  pythonEnv = python3.withPackages (p: with p; [ tqdm ]);
in
stdenv.mkDerivation rec {
  pname = "phockup";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ivandokov";
    repo = "phockup";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-wnTdNzH/2Lcr3FXqm84ITiAmbKpFWLo/0/cf0fCv+4M=";
=======
    sha256 = "sha256-ge34Iv/+B0xdrSNc7w3nZJw0DHBUvuh2k/I8v/RRg10=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # based roughly on https://github.com/ivandokov/phockup#linux-without-snap
    mkdir -p $out/bin $out/opt
    mv * $out/opt
    makeWrapper ${pythonEnv.interpreter} $out/bin/phockup --add-flags "$out/opt/phockup.py" --suffix PATH : ${lib.makeBinPath [ exiftool ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Media sorting tool to organize photos and videos from your camera in folders by year, month and day";
    homepage = "https://github.com/ivandokov/phockup";
    license = licenses.mit;
    maintainers = with maintainers; [ aanderse ];
  };
}
