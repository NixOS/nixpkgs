{
  lib,
  stdenv,
  libgit2,
  fetchgit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stagit";
  version = "1.3";

  src = fetchgit {
    url = "git://git.codemadness.org/stagit";
    rev = finalAttrs.version;
    sha256 = "sha256-GPJs63ElNBJFn571ZKLiQ8pABr4jX/fj2t53wDS284o=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libgit2 ];

  meta = {
    description = "Git static site generator";
    homepage = "https://git.codemadness.org/stagit/file/README.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      jb55
      sikmir
    ];
  };
})
