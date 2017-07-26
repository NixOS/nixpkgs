{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "git-radar-${version}";
  version = "0.5";

  phases = [ "unpackPhase" "installPhase" ];

  dontInstallSrc = true;

  src = fetchFromGitHub {
    owner = "michaeldfallen";
    repo = "git-radar";
    rev = "v${version}";
    sha256 = "1915aqx8bfc4xmvhx2gfxv72p969a6rn436kii9w4yi38hibmqv9";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp git-radar fetch.sh prompt.bash prompt.zsh radar-base.sh $out
    ln -s $out/git-radar $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/michaeldfallen/git-radar;
    license = licenses.mit;
    description = "A tool you can add to your prompt to provide at-a-glance information on your git repo";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ kamilchm ];
  };
}
