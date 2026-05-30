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
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "aslafy-z";
    repo = "helm-git";
    rev = "v${version}";
    sha256 = "sha256-JSy6bI6XHW4JkXwffbfSFJj46BUqJvRG83sfOi8AcHM=";
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

  meta = {
    description = "Helm downloader plugin that provides GIT protocol support";
    homepage = "https://github.com/aslafy-z/helm-git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
