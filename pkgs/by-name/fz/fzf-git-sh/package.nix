{
  stdenv,
  lib,
  bash,
  bat,
  coreutils,
  fetchFromGitHub,
  findutils,
  fzf,
  gawk,
  git,
  gnugrep,
  gnused,
  util-linux,
  xdg-utils,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "fzf-git-sh";
  version = "0-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "3ec3e97d1cc75ec97c0ab923ed5aa567aee01a5e";
    hash = "sha256-hkxbFYCogrIhnAGs3lcqY8Zv51/TAfM6zB9G78UuYSA=";
  };

  dontBuild = true;

  postPatch = ''
    sed -i \
      -e "s,\bfzf\b,${fzf}/bin/fzf," \
      -e "s,\bawk\b,${gawk}/bin/awk," \
      -e "s,\bbash\b,${bash}/bin/bash," \
      -e "s,\bbat\b,${bat}/bin/bat," \
      -e "s,\bcat\b,${coreutils}/bin/cat," \
      -e "s,\bcut\b,${coreutils}/bin/cut," \
      -e "s,\bhead\b,${coreutils}/bin/head," \
      -e "s,\buniq\b,${coreutils}/bin/uniq," \
      -e "s,\bcolumn\b,${util-linux}/bin/column," \
      -e "s,\bgrep\b,${gnugrep}/bin/grep," \
      -e "s,\bsed\b,${gnused}/bin/sed," \
      -e "s,\bxargs\b,${findutils}/bin/xargs," \
      -e "s,\bxdg-open\b,${xdg-utils}/bin/xdg-open," \
      -e "/display-message\|fzf-git-\$o-widget\|\burl=\|\$remote_url =~ /!s,\bgit\b,${git}/bin/git,g" \
      -e "s,__fzf_git=.*BASH_SOURCE.*,__fzf_git=$out/share/${pname}/fzf-git.sh," \
      -e "/__fzf_git=.*readlink.*/d" \
      fzf-git.sh
  '';

  installPhase = ''
    install -D fzf-git.sh $out/share/${pname}/fzf-git.sh
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf-git.sh";
    description = "Bash and zsh key bindings for Git objects, powered by fzf";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
