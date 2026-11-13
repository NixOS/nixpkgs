{
  lib,
  stdenv,
  asciidoc,
  fetchFromGitLab,
  git,
  makeWrapper,
  python3,
  rcs,
  asciidoctor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simple-revision-control";
  version = "1.41";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "src";
    tag = finalAttrs.version;
    hash = "sha256-i5i6+RmQ/70ul2r/NC6xv/8sUP3+8mkQIDgyC1NrSrI=";
  };

  nativeBuildInputs = [
    asciidoc
    asciidoctor
    makeWrapper
  ];

  buildInputs = [
    git
    python3
    rcs
  ];

  strictDeps = true;

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/src \
      --suffix PATH ":" "${rcs}/bin"
  '';

  meta = {
    homepage = "http://www.catb.org/esr/src/";
    description = "Simple single-file revision control";
    longDescription = ''
      SRC, acronym of Simple Revision Control, is RCS/SCCS reloaded with a
      modern UI, designed to manage single-file solo projects kept more than one
      to a directory. Use it for FAQs, ~/bin directories, config files, and the
      like. Features integer sequential revision numbers, a command set that
      will seem familiar to Subversion/Git/hg users, and no binary blobs
      anywhere.
    '';
    changelog = "https://gitlab.com/esr/src/-/raw/${finalAttrs.version}/NEWS.adoc";
    license = lib.licenses.bsd2;
    mainProgram = "src";
    maintainers = [ ];
    inherit (python3.meta) platforms;
  };
})
