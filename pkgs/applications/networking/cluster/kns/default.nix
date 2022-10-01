{ stdenvNoCC, lib, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "kns";
  version = "50b6370c88136a580599c913f0fae2cb24981dc1";

  src = fetchFromGitHub {
    owner = "blendle";
    repo = pname;
    rev = version;
    sha256 = "1y7m6ln3xricmrwf8638hqbmnbipfag1c1c04apfd4vcj7sqzm6b";
  };

  strictDeps = true;
  buildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    install -m755 ./bin/kns -D $out/bin/kns

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kubernetes namespace switcher";
    homepage = "https://github.com/blendle/kns";
    license = licenses.isc;
    maintainers = with maintainers; [ crutonjohn ];
    platforms = platforms.linux;
  };
}

