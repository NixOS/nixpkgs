{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "git-radar-${version}";
  version = "0.3.2";

  phases = [ "unpackPhase" "installPhase" ];

  dontInstallSrc = true;

  src = fetchFromGitHub {
    owner = "michaeldfallen";
    repo = "git-radar";
    rev = "v${version}";
    sha256 = "1028462b4kqxx66vjv7r8nnr6bi3kw11fixpqyg2srqriha6447p";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp git-radar fetch.sh prompt.bash prompt.zsh radar-base.sh $out
    ln -s $out/git-radar $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/michaeldfallen/git-radar;
    license = licenses.mit;
    description = "Git-radar is a tool you can add to your prompt to provide at-a-glance information on your git repo";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ kamilchm ];
  };
}
