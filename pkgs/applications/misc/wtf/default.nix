{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
, stdenv
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dszc3igfvlb6dgf5whyhw72id39lqqmgpd42kyqx5yjf5dw2wg7";
   };

  vendorSha256 = "1wcqk8lfv3jq7dfaj9dj8bzsmq2qislzs1m38gx1hh4jwg1rn2cn";

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
