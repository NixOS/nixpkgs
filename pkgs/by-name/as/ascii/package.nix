{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  asciidoctor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii";
  version = "3.30";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "ascii";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-TE9YR5Va9tXaf2ZyNxz7d8lZRTgnD4Lz7FyqRDl1HNY=";
  };

  nativeBuildInputs = [
    asciidoctor
  ];

  prePatch = ''
    sed -i -e "s|^PREFIX = .*|PREFIX = $out|" Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Interactive ASCII name and synonym chart";
    mainProgram = "ascii";
    homepage = "http://www.catb.org/~esr/ascii/";
    changelog = "https://gitlab.com/esr/ascii/-/blob/${finalAttrs.version}/NEWS.adoc";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
})
