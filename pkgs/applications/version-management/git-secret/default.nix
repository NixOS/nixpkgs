{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  git,
  gnupg,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "git-secret";
  version = "0.5.0";

  src = fetchFromGitHub {
    repo = "git-secret";
    owner = "sobolevn";
    rev = "v${version}";
    sha256 = "sha256-Vdlv3H99BZcT1O66ZCpq5olENOaUSubx58B1PQ/OlMU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D git-secret $out/bin/git-secret

    wrapProgram $out/bin/git-secret \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          gnupg
          gawk
        ]
      }"

    mkdir $out/share
    cp -r man $out/share
  '';

  meta = {
    description = "A bash-tool to store your private data inside a git repository";
    homepage = "https://git-secret.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lo1tuma ];
    platforms = lib.platforms.all;
    mainProgram = "git-secret";
  };
}
