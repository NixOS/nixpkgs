{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  perl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-octopus";
  version = "1.4";

  installFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  # perl provides shasum
  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${
        lib.makeBinPath [
          git
          perl
        ]
      }
    done
  '';

  src = fetchFromGitHub {
    owner = "lesfurets";
    repo = "git-octopus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QWqCiYOPuCE8owwutlM+dVuXnoqsG8GeudMqeWYP5pI=";
  };

  meta = {
    homepage = "https://github.com/lesfurets/git-octopus";
    description = "Continuous merge workflow";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mic92 ];
  };
})
