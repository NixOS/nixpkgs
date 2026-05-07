{
  lib,
  less,
  ncurses,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "circumflex";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-C5zjbs/34SUX23KDLLQvrVH9dNYT125cpnSCWyUhSqw=";
  };

  vendorHash = "sha256-zz0nYzjwiWnknfe82RAtCK7gOaI3j8lwwPxKqE0aGSA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clx \
      --prefix PATH : ${
        lib.makeBinPath [
          less
          ncurses
        ]
      }
  '';

  meta = {
    description = "Command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mktip ];
    mainProgram = "clx";
  };
})
