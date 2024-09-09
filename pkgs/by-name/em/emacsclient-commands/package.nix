{ lib
, fetchFromGitHub
, buildGoModule
, gnumake
}:

buildGoModule {
  pname = "emacsclient-commands";
  version = "unstable-2023-09-22";

  src = fetchFromGitHub {
    owner = "szermatt";
    repo = "emacsclient-commands";
    rev = "8f5c8a877794ed51f8225036e36fd5ce272b17f3";
    hash = "sha256-OlcB5VqWYdl0wz1y8nmG6Xgdf5IPOUQ31UG1TDxQAis=";
  };

  vendorHash = "sha256-8oREed2Igz5UvUTDdOFwW5wQQy3H8Xj8epxo6gqnZFA=";

  buildInputs = [ gnumake ];

  buildPhase = ''
    runHook preBuild
    DESTDIR=$out/ make install
    runHook postBuild
  '';

  meta = with lib; {
    description = "Collection of small shell utilities that connect to a local Emacs server";
    homepage = "https://github.com/szermatt/emacsclient-commands";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ binarycat ];
  };
}
