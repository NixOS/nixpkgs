{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "claude-code-config-switcher";
  version = "0-unstable-2025-07-15";

  src = fetchFromGitHub {
    owner = "yoyooyooo";
    repo = "claude-code-config";
    rev = "449866d7daae8087abdfb8275eeb1367d8e35d72";
    hash = "sha256-mVs9IHXl7zYz77Jq3KjNV5/cR7yywiUvMWaORdjZiYI=";
  };

  propagatedBuildInputs = [ jq ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ccc $out/bin/claude-code-config-switcher
    chmod +x $out/bin/claude-code-config-switcher

    # Create symbolic links for convenience
    ln -s claude-code-config-switcher $out/bin/ccc
    ln -s claude-code-config-switcher $out/bin/cccs

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Claude Code configuration switcher - tool for managing different Claude API configurations";
    homepage = "https://github.com/yoyooyooo/claude-code-config";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MiyakoMeow ];
    platforms = lib.platforms.unix;
    mainProgram = "claude-code-config-switcher";
  };
}
