{lib}:

micro = buildGoModule rec {
  pname = "micro";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
  };

  meta = with lib; {
    description = "terminal-based text editor similar to nano";
    homepage = "https://micro-editor.github.io";
    license = licenses.mit;
    maintainers = [ maintainers.quintasan ]
    mainProgram = "micro";
    platforms = platforms.all;
  }
}
