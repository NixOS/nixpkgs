{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.21.0";

  overrideModAttrs = _oldAttrs : _oldAttrs // {
    preBuild = ''export GOPROXY="https://gocenter.io"'';
  };

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sd8vrx7nak0by4whdmd9jzr66zm48knv1w1aqi90709fv98brm9";
  };

  modSha256 = "0jgq9ql27x0kdp59l5drisl5v7v7sx2wy3zqjbr3bqyh3vdx19ic";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/wtf" --prefix PATH : "${ncurses.dev}/bin"
  '';

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
