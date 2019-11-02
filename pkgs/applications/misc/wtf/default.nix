{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.23.0";

  overrideModAttrs = _oldAttrs : _oldAttrs // {
    preBuild = ''export GOPROXY="https://gocenter.io"'';
  };

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bhk81jmv6rq8h898lmvrh9v356310fbi82lvakmgay7nvzk9a1c";
   };

  modSha256 = "1ndb7zbhaq0cnd8fd05fvb62qi0mxilgydz42qqz2z4fkbx9gp3m";

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
