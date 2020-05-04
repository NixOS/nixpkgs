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

  modSha256 = "0csxc5q7i2iq8z71ysfan2kwf4mghi89i5zja5g1a4cvmcabiq1g";

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
