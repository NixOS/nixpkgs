{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  fish,
  unstableGitUpdater,
  writeShellScriptBin,
  zsh,
}:

let
  batProbe = writeShellScriptBin "bat" ''
    echo bat-from-path
  '';
  fzfProbe = writeShellScriptBin "fzf" ''
    echo fzf-from-path
  '';
  bashProbe = writeShellScriptBin "bash" ''
    if [ "$1" != "$EXPECTED_FZF_GIT_SH" ]; then
      echo "unexpected fzf-git.sh path: $1" >&2
      exit 1
    fi
    exec ${bash}/bin/bash "$@"
  '';
in
stdenv.mkDerivation {
  pname = "fzf-git-sh-unwrapped";
  version = "0-unstable-2026-08-06";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "d5b0a5dcd1e073b8bfca45338d5dfad3e5642471";
    hash = "sha256-j7co9UjWdSMC7Ojyhuz2bIALrucF94o+irF4pJ6hgG4=";
  };

  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -D fzf-git.sh $out/share/fzf-git-sh/fzf-git.sh
    install -D fzf-git.fish $out/share/fzf-git-sh/fzf-git.fish

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    bash
    batProbe
    fish
    fzfProbe
    zsh
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    cmp fzf-git.sh $out/share/fzf-git-sh/fzf-git.sh
    cmp fzf-git.fish $out/share/fzf-git-sh/fzf-git.fish

    export HOME=$(mktemp -d)

    ${bash}/bin/bash --noprofile --norc -c '
      source "$out/share/fzf-git-sh/fzf-git.sh" --run list_bindings >/dev/null
      test "$__fzf_git" = "$out/share/fzf-git-sh/fzf-git.sh"
      test "$(eval "$(__fzf_git_cat)" </dev/null)" = bat-from-path
      test "$(_fzf_git_fzf)" = fzf-from-path
      ${bash}/bin/bash "$__fzf_git" --run list_bindings | grep -Fq "CTRL-G CTRL-F for Files"
    '

    ${zsh}/bin/zsh -fc '
      source "$out/share/fzf-git-sh/fzf-git.sh" --run list_bindings >/dev/null
      test "$__fzf_git" = "$out/share/fzf-git-sh/fzf-git.sh"
      test "$(_fzf_git_fzf)" = fzf-from-path
      ${bash}/bin/bash "$__fzf_git" --run list_bindings | grep -Fq "CTRL-G CTRL-F for Files"
    '

    EXPECTED_FZF_GIT_SH="$out/share/fzf-git-sh/fzf-git.sh" \
      PATH=${bashProbe}/bin:$PATH \
      ${fish}/bin/fish --no-config -c '
        source "$out/share/fzf-git-sh/fzf-git.fish"
        __fzf_git_sh list_bindings | string match --quiet "*CTRL-G CTRL-F for Files*"
      '

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/junegunn/fzf-git.sh";
    description = "Bash, zsh and fish key bindings for Git objects, powered by fzf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.all;
  };
}
