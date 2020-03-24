{ buildGoModule
, fetchFromGitHub
, stdenv
, makeWrapper
, ncurses
, Security
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j184s82bnnhrpm7vdsqg7i3xfm2wqz8jmwqxjkfw87ifgvaha5d";
   };

  modSha256 = "14qbjv8rnidfqxzqhli7jyj4573s0swwypdj11mpykcrzk9by8xk";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  meta = with stdenv.lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
