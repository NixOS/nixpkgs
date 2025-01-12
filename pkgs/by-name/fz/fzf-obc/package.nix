{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fzf-obc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rockandska";
    repo = pname;
    rev = version;
    sha256 = "sha256-KIAlDpt1Udl+RLp3728utgQ9FCjZz/OyoG92MOJmgPI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fzf-obc/{bin,lib/fzf-obc,plugins/{kill,gradle}}
    install -m644 bin/* $out/share/fzf-obc/bin
    install -m644 lib/fzf-obc/* $out/share/fzf-obc/lib/fzf-obc
    install -m644 plugins/kill/* $out/share/fzf-obc/plugins/kill
    install -m644 plugins/gradle/* $out/share/fzf-obc/plugins/gradle
  '';

  meta = with lib; {
    homepage = "https://fzf-obc.readthedocs.io";
    description = "Completion script adding fzf over all know bash completion functions";
    license = licenses.unfree;
    maintainers = with maintainers; [ loicreynier ];
  };
}
