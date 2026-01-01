{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  findutils,
  gitMinimal,
  gnugrep,
  gnused,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "helm-git";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aslafy-z";
    repo = "helm-git";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jgHFmANmxDS75k0JQIiT8DDw9nSppw1EZeEWM3jirsg=";
=======
    sha256 = "sha256-gMx61fhAaiYHYd/so65DEBKANZZO826AFLU1FIE3hSs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            gitMinimal
            gnugrep
            gnused
          ]
        }

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Helm downloader plugin that provides GIT protocol support";
    homepage = "https://github.com/aslafy-z/helm-git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
=======
  meta = with lib; {
    description = "Helm downloader plugin that provides GIT protocol support";
    homepage = "https://github.com/aslafy-z/helm-git";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
