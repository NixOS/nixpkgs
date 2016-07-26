{ stdenv, fetchFromGitHub, pkgconfig
, libX11, libxcb, cairo, gtk, pango, python27, python3
}:

stdenv.mkDerivation rec {
  name = "lighthouse-${date}";
  date = "2016-07-20";

  src = fetchFromGitHub {
    owner = "emgram769";
    repo = "lighthouse";
    rev = "d1813ef8e2aca9f6b3609b1e0c6d1d5ee683281a";
    sha256 = "0v6ylm49f1b44zwq1y1gqxp2csyqblplr24ajllc2q3r0sc9m1ys";
   };

  buildInputs = [
    pkgconfig libX11 libxcb cairo gtk pango python27 python3
  ];

  makeFlags = [ "PREFIX=\${out}" ];

  preFixup = "chmod +x $out/share/lighthouse/.config/lighthouse/google.py";

  postFixup = "chmod -x $out/share/lighthouse/.config/lighthouse/google.py";

  meta = with stdenv.lib; {
    description = "A simple flexible popup dialog to run on X";
    homepage = https://github.com/emgram769/lighthouse;
    license = licenses.mit;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = platforms.linux;
  };

}
