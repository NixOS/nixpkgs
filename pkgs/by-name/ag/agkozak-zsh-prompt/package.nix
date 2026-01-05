{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "agkozak-zsh-prompt";
  version = "3.11.4";

  src = fetchFromGitHub {
    owner = "agkozak";
    repo = "agkozak-zsh-prompt";
    tag = "v${version}";
    sha256 = "sha256-FC9LIZaS6fV20qq6cJC/xQvfsM3DHXatVleH7yBgoNg=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/site-functions"

    mkdir -p "$plugindir"
    cp -r -- lib/*.zsh agkozak-zsh-prompt.plugin.zsh prompt_agkozak-zsh-prompt_setup "$plugindir"/
  '';

  meta = with lib; {
    description = "Fast, asynchronous Zsh prompt";
    homepage = "https://github.com/agkozak/agkozak-zsh-prompt";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ambroisie ];
  };
}
