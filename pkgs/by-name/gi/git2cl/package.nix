{
  fetchFromGitLab,
  lib,
  perl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git2cl";
  version = "3.0";

  src = fetchFromGitLab {
    owner = "jas";
    repo = "git2cl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KEEUKSP7+05VIb/EhuCy0t1qP/UU0iqNzU4AacbdpTg=";
  };

  buildInputs = [ perl ];
  installPhase = ''
    install -D -m755 git2cl $out/bin/git2cl
    install -D -m644 README.md $out/share/doc/git2cl/README.md
  '';

  meta = {
    homepage = "https://savannah.nongnu.org/projects/git2cl";
    description = "Convert git logs to GNU style ChangeLog files";
    platforms = lib.platforms.unix;
    mainProgram = "git2cl";
  };
})
