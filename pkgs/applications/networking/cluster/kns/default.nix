{ stdenvNoCC, lib, fetchFromGitHub, fzf, kubectl }:

stdenvNoCC.mkDerivation rec {
  pname = "kns";
  version = "unstable-2022-04-25";

  src = fetchFromGitHub {
    owner = "blendle";
    repo = pname;
    rev = "86502949c31432bd95895cfb26d1c5893c533d5c";
    sha256 = "sha256-8AR/fEKPAfiKCZrp/AyJo3Ic8dH7SfncYZSdQA2GywQ=";
  };

  strictDeps = true;

  buildInputs = [ fzf kubectl ];

  installPhase = ''
    runHook preInstall

    substituteInPlace bin/kns bin/ktx --replace fzf ${fzf}/bin/fzf --replace kubectl ${kubectl}/bin/kubectl
    install -D -m755 -t $out/bin bin/kns bin/ktx

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

