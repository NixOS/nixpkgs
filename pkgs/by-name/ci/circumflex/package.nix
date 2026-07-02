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
  version = "4.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-JJgLRRE0Fh/oaZLZo0hLCfwUHJXBvXXfTNdmQMNUM7A=";
  };

  vendorHash = "sha256-in6yPiT/SqRaw6hFF2gCmBwGcJ315Qej3HuM7TF5MaE=";

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
