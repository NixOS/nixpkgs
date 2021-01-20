{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
, stdenv
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "01zydr1w8byjhxf4xj6z001q4ynq0452cn332ap1l1w0dmx9mxyr";
   };

  vendorSha256 = "1xyai417l8q44b562ssp5qqw04klrhg5397ahr4pc3i30csz8a7a";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." ];

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
    broken = stdenv.isDarwin;
  };
}
