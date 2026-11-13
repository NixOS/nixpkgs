{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "git-fire";
  version = "0.2.3-unstable-2017-08-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qw3rtman";
    repo = "git-fire";
    rev = "d72b68ed356f726c77c60294f9220275f16c9931";
    hash = "sha256-YhW59cpiVmaIEIw068B5xyVfHFkLTnkp8GF0KT2cvME=";
  };

  installPhase = ''
    runHook preInstall
    install -D -m755 $src/git-fire $out/bin/git-fire
    runHook postInstall
  '';

  meta = {
    description = ''
      Push ALL changes in a git repository
    '';
    longDescription = ''
      In the event of an emergency (fire, etc.), automatically commit all changes/files in a repository, pushing to all known remotes all commits and stashes.
    '';
    homepage = "https://github.com/qw3rtman/git-fire";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ swflint ];
    mainProgram = "git-fire";
  };
}
