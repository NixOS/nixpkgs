{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.22.0";

  overrideModAttrs = _oldAttrs : _oldAttrs // {
    preBuild = ''export GOPROXY="https://gocenter.io"'';
  };

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d8lp94cw8rh9r9y64awxafhw9fmp33v3m761gzy500hrxal2rzb";
   };

  modSha256 = "0m180571j4564py5mzdcbyypk71fdlp2vkfdwi6q85nd2q94sx6h";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
