{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, git
}:

buildNpmPackage {
  pname = "overleaf-gitbridge";
  version = "unstable-2022-06-17";

  src = fetchFromGitHub {
    owner = "camillemndn";
    repo = "overleaf-gitbridge";
    rev = "16996ba981aa7fe687606d934ea3bcfc2282bc6a";
    hash = "sha256-p4Lwl8yxVsIX3fkG8n8932GFaD+PGW3tA9mTvkV5owo=";
  };

  npmDepsHash = "sha256-0AaGl2sJ7e3evMKaRNAnGQvovHNW1w2odJPl8fkTTh8=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/overleaf-gitbridge \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = with lib; {
    description = "Bridge between Overleaf CE and git";
    homepage = "https://github.com/camillemndn/overleaf-gitbridge";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn julienmalka ];
    platforms = platforms.all;
  };
}
