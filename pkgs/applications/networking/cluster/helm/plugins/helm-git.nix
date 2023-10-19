{ lib
, stdenv
, fetchFromGitHub
, coreutils
, findutils
, git
, gnugrep
, gnused
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "helm-git";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "aslafy-z";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hvycqibmlw2zw3nm8rn73v5x1zcgm2jrfdlljbvc1n4n5vnzdrg";
  };

  nativeBuildInputs = [ makeWrapper ];

  # NOTE: helm-git is comprised of shell scripts.
  dontBuild = true;

  installPhase = ''
    install -dm755 $out/helm-git
    install -m644 -Dt $out/helm-git plugin.yaml
    cp helm-git helm-git-plugin.sh $out/helm-git/

    patchShebangs $out/helm-git/helm-git{,-plugin.sh}
    wrapProgram $out/helm-git/helm-git \
        --prefix PATH : ${lib.makeBinPath [ coreutils findutils git gnugrep gnused ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Helm downloader plugin that provides GIT protocol support";
    homepage = "https://github.com/aslafy-z/helm-git";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
