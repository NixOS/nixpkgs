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
  zsh,
  fish,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "fzf-git-sh";
  version = "0-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "110c0a10b744131b90861aa1d1fff6fbe0794f9d";
    hash = "sha256-pu3qAtY/M5IPfRHGKhC1rFscSCBvgnjaD2KlAXbZ8L0=";
  };

  dontBuild = true;
  doInstallCheck = true;

  postPatch = ''
    sed -i \
      -e "/fzf-git-\$o-widget/!s,\bfzf\b,${lib.getExe fzf}," \
      -e "s,\bawk\b,${lib.getExe' gawk "awk"}," \
      -e "s,\bbash\b,${lib.getExe bash}," \
      -e "s,\bbat\b,${lib.getExe bat}," \
      -e "s,\bcat\b,${lib.getExe' coreutils "cat"}," \
      -e "s,\bcut\b,${lib.getExe' coreutils "cut"}," \
      -e "s,\bhead\b,${lib.getExe' coreutils "head"}," \
      -e "s,\buniq\b,${lib.getExe' coreutils "uniq"}," \
      -e "s,\bcolumn\b,${lib.getExe' util-linux "column"}," \
      -e "s,\bgrep\b,${lib.getExe gnugrep}," \
      -e "s,\bsed\b,${lib.getExe gnused}," \
      -e "s,\bxargs\b,${lib.getExe' findutils "xargs"}," \
      -e "s,\bxdg-open\b,${lib.getExe' xdg-utils "xdg-open"}," \
      -e "s,\bzsh\b,${lib.getExe zsh}," \
      -e "/display-message\|fzf-git-\$o-widget\|\burl=\|\$remote_url =~ /!s,\bgit\b,${lib.getExe git},g" \
      -e "s,__fzf_git=.*BASH_SOURCE.*,__fzf_git=$out/share/${pname}/fzf-git.sh," \
      -e "/__fzf_git=.*readlink.*/d" \
      fzf-git.sh

    sed -i \
      -e "s,\bbash\b,${lib.getExe bash}," \
      -e "s,\''$fzf_git_sh_path\b,$out/share/${pname}," \
      fzf-git.fish

    sed -i \
      -e "s,\bbash\b,${lib.getExe bash},g" \
      -e "s,\bcat\b,${lib.getExe' coreutils "cat"}," \
      -e "s,__fzf_git_tmux=.*BASH_SOURCE.*,__fzf_git_tmux=$out/share/${pname}/fzf-git.tmux," \
      -e "s,__fzf_git=.*/fzf-git.sh\$,__fzf_git=$out/share/${pname}/fzf-git.sh," \
      -e "/__fzf_git_tmux=.*readlink.*/d" \
      fzf-git.tmux
  '';

  installPhase = ''
    install -D fzf-git.sh $out/share/${pname}/fzf-git.sh
    install -D fzf-git.fish $out/share/${pname}/fzf-git.fish
    install -D fzf-git.tmux $out/share/${pname}/fzf-git.tmux
  '';

  # Smoke test
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    ${lib.getExe bash} -c "source $out/share/${pname}/fzf-git.sh"
    ${lib.getExe fish} -c "source $out/share/${pname}/fzf-git.fish"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/junegunn/fzf-git.sh";
    description = "Bash, zsh, fish and tmux key bindings for Git objects, powered by fzf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.all;
  };
}
