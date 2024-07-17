{
  lib,
  buildNimPackage,
  fetchFromGitLab,
  enableShells ? [
    "bash"
    "zsh"
    "fish"
    "sh"
    "posh"
    "codium"
  ],
}:

buildNimPackage (finalAttrs: {
  pname = "swaycwd";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "cab404";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-R/LnojbA0vBQVivGLaoM0+M4qVJ7vjf4kggB59i896w=";
  };

  preConfigure = ''
    {
      echo 'let enabledShells: seq[string] = @${builtins.toJSON enableShells}'
      echo 'export enabledShells'
    } > src/shells.nim
  '';

  nimFlags = [ "--opt:speed" ];

  meta = with lib; {
    homepage = "https://gitlab.com/cab404/swaycwd";
    description = "Returns cwd for shell in currently focused sway window, or home directory if cannot find shell";
    maintainers = with maintainers; [ cab404 ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    mainProgram = "swaycwd";
  };
})
