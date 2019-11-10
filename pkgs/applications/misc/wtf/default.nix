{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.24.0";

  overrideModAttrs = _oldAttrs : _oldAttrs // {
    preBuild = ''export GOPROXY="https://gocenter.io"'';
  };

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jz7hjcm0hfxcih2zplp47wx6lyvhhzj9ka4ljqrx0i4l7cm9ahs";
   };

  modSha256 = "03vj6q1ln71r685k2j91ycj6xxrc688pj4bdc561693r20sr49xj";

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
