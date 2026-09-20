{
  bash,
  bat,
  coreutils,
  findutils,
  fish,
  fzf,
  fzf-git-sh-unwrapped,
  gawk,
  git,
  gnugrep,
  gnused,
  util-linux,
  xdg-utils,
  zsh,
}:

fzf-git-sh-unwrapped.overrideAttrs (previousAttrs: {
  pname = "fzf-git-sh";

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
      -e "s,\bzsh\b,${zsh}/bin/zsh," \
      -e "/display-message\|fzf-git-\$o-widget\|\burl=\|\$remote_url =~ /!s,\bgit\b,${git}/bin/git,g" \
      -e "s,__fzf_git=.*BASH_SOURCE.*,__fzf_git=$out/share/fzf-git-sh/fzf-git.sh," \
      -e "/__fzf_git=.*readlink.*/d" \
      fzf-git.sh

    sed -i \
      -e "s,\bbash\b,${bash}/bin/bash," \
      -e "s,\''$fzf_git_sh_path\b,$out/share/fzf-git-sh," \
      fzf-git.fish
  '';

  installCheckPhase = ''
    export HOME=$(mktemp -d)

    ${bash}/bin/bash --noprofile --norc -c '
      source "$out/share/fzf-git-sh/fzf-git.sh" --run list_bindings >/dev/null
      test "$__fzf_git" = "$out/share/fzf-git-sh/fzf-git.sh"
      ${bash}/bin/bash "$__fzf_git" --run list_bindings | ${gnugrep}/bin/grep -Fq "CTRL-G CTRL-F for Files"
    '

    ${zsh}/bin/zsh -fc '
      source "$out/share/fzf-git-sh/fzf-git.sh" --run list_bindings >/dev/null
      test "$__fzf_git" = "$out/share/fzf-git-sh/fzf-git.sh"
      ${bash}/bin/bash "$__fzf_git" --run list_bindings | ${gnugrep}/bin/grep -Fq "CTRL-G CTRL-F for Files"
    '

    ${fish}/bin/fish --no-config -c "source $out/share/fzf-git-sh/fzf-git.fish"

    ${gnugrep}/bin/grep -Fq '${fzf}/bin/fzf' $out/share/fzf-git-sh/fzf-git.sh
    ${gnugrep}/bin/grep -Fq '${bat}/bin/bat' $out/share/fzf-git-sh/fzf-git.sh
    ${gnugrep}/bin/grep -Fq "__fzf_git=$out/share/fzf-git-sh/fzf-git.sh" $out/share/fzf-git-sh/fzf-git.sh
  '';

  passthru = previousAttrs.passthru // {
    unwrapped = fzf-git-sh-unwrapped;
  };
})
