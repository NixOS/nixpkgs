{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v6yafpz3sycq6yb7w4dyxqclszvdgwbyhqs5ii8ckynqcf6ifn7";
   };

  vendorSha256 = "1q54bl1z9ljpsf63i5r6vzv7f143slja0n8lyppaxxdcg18h8gn0";

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
  };
}