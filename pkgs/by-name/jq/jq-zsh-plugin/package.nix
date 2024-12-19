{
  lib,
  stdenv,
  fetchFromGitHub,
  fzf,
  jq,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "jq-zsh-plugin";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "reegnz";
    repo = "jq-zsh-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-q/xQZ850kifmd8rCMW+aAEhuA43vB9ZAW22sss9e4SE=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/jq-zsh-plugin/
    cp jq.plugin.zsh $out/share/jq-zsh-plugin
    cp -r bin/ $out/share/jq-zsh-plugin
    substituteInPlace $out/share/jq-zsh-plugin/bin/jq-repl --replace-fail "fzf \\" "${fzf}/bin/fzf \\"
    substituteInPlace $out/share/jq-zsh-plugin/jq.plugin.zsh --replace-fail ":-jq" ":-${jq}/bin/jq"
    substituteInPlace $out/share/jq-zsh-plugin/bin/jq-paths --replace-fail ":-jq" ":-${jq}/bin/jq"
    substituteInPlace $out/share/jq-zsh-plugin/bin/jq-repl --replace-fail ":-jq" ":-${jq}/bin/jq"
    substituteInPlace $out/share/jq-zsh-plugin/bin/jq-repl-preview --replace-fail ":-jq" ":-${jq}/bin/jq"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactively build jq expressions in Zsh";
    homepage = "https://github.com/reegnz/jq-zsh-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.vinnymeller ];
  };
}
