{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
, stdenv
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nP56HzjtIg9EIOBda9TQl8soUqlGfRmixidWrmQ7+vs=";
   };

  vendorSha256 = "sha256-yD4BUauYvyGk/D0Gr5Z15xWPtI/ZR9xTbmeS6RAxw1o=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

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
