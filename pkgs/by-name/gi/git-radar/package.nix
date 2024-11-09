{ coreutils-prefixed, lib, makeWrapper, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "git-radar";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "michaeldfallen";
    repo = "git-radar";
    rev = "v${version}";
    sha256 = "0c3zp8s4w7m4s71qgwk1jyfc8yzw34f2hi43x1w437ypgabwg81j";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp git-radar fetch.sh prompt.bash prompt.zsh radar-base.sh $out
    ln -s $out/git-radar $out/bin
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram $out/git-radar --prefix PATH : ${lib.makeBinPath [ coreutils-prefixed ]}
    ''}
  '';

  meta = with lib; {
    homepage = "https://github.com/michaeldfallen/git-radar";
    license = licenses.mit;
    description = "Tool you can add to your prompt to provide at-a-glance information on your git repo";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ kamilchm ];
    mainProgram = "git-radar";
  };
}
