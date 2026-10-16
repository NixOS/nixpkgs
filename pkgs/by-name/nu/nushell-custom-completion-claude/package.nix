{
  lib,
  stdenv,
  fetchurl,
  nushell,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nushell-custom-completion-claude";
  version = "0-unstable-2026-03-12";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/nushell/nu_scripts/196d94338d382561e7bacb29948ffcfa5ff1b2a1/custom-completions/claude/claude-completions.nu";
    hash = "sha256-SzdCyuvCpDfuBfXbXylEYYwXf/Zg+zoK5M+73IbACiM=";
  };

  # It's a nushell script, so it doesn't need to be built
  dontBuild = true;
  dontUnpack = true;

  runtimeDeps = [ nushell ];

  doCheck = true;

  checkPhase = ''
    ${lib.getExe nushell} --no-config-file $src
  '';

  installPhase = ''
    install -Dm644 $src $out/share/nushell/custom-completions/claude.nu
  '';

  meta = with lib; {
    description = "Claude completion for Nushell";
    homepage = "https://github.com/nushell/nu_scripts/tree/main/custom-completions/claude";
    license = licenses.mit;
    maintainers = with maintainers; [ asakura ];
    platforms = platforms.all;
  };
})
