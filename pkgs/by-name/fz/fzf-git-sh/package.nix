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
  version = "0-unstable-2025-10-21";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "c823ffd521cb4a3a65a5cf87f1b1104ef651c3de";
    hash = "sha256-G5b6s3p4Lrh2YQyBKE3Lzh78USR1tKlR/YqTMr3mXsI=";
  };

  dontBuild = true;
  doInstallCheck = true;

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
      -e "s,__fzf_git=.*BASH_SOURCE.*,__fzf_git=$out/share/${pname}/fzf-git.sh," \
      -e "/__fzf_git=.*readlink.*/d" \
      fzf-git.sh

    sed -i \
      -e "s,\bbash\b,${bash}/bin/bash," \
      -e "s,\''$fzf_git_sh_path\b,$out/share/${pname}," \
      fzf-git.fish
  '';

  installPhase = ''
    install -D fzf-git.sh $out/share/${pname}/fzf-git.sh
    install -D fzf-git.fish $out/share/${pname}/fzf-git.fish
  '';

  # Smoke test
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    ${bash}/bin/bash -c "source $out/share/${pname}/fzf-git.sh"
    ${fish}/bin/fish -c "source $out/share/${pname}/fzf-git.fish"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf-git.sh";
    description = "Bash, zsh and fish key bindings for Git objects, powered by fzf";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
