{ stdenvNoCC, lib, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "kns";
  version = "unstable-2022-03-03";

  src = fetchFromGitHub {
    owner = "blendle";
    repo = pname;
    rev = "adddff3690d6bde62844e68e0edf304023927a9b";
    sha256 = "sha256-zcJaH+Uyc/rCDRlQi+lSKaG7z4VWlNZ13klDnvL3Jgc=";
  };

  strictDeps = true;

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

