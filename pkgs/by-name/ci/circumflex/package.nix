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
  version = "3.9";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-Wv0CSLXM6zMkK0FFAoe0oPpfD3Fq743jz+69qWh0njs=";
  };

  vendorHash = "sha256-SlXTLL/6OElR5yJ86K2voq6Ui9Z+9CvXVjG0im92CTk=";

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
