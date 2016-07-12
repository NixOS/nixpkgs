{ stdenv, fetchFromGitHub, pkgconfig
, libX11, libxcb, cairo, gtk, pango, python27, python3
}:

stdenv.mkDerivation rec {
  name = "lighthouse-${date}";
  date = "2016-01-26";

  src = fetchFromGitHub {
    owner = "emgram769";
    repo = "lighthouse";
    rev = "bf11f111572475e855b0329202a14c9e128c7e57";
    sha256 = "1ppika61vg4sc9mczbkjqy2mhgxqg57xrnsmmq0h2lyvj0yhg3qn";
   };

  buildInputs = [
    pkgconfig libX11 libxcb cairo gtk pango python27 python3
  ];

  patches = [ ./Makefile.patch ];

  lighthouseInstaller = ''
    #!${stdenv.shell}
    cp -r $out/share/lighthouse/.config/lighthouse \$HOME/.config
    chmod -R +w \$HOME/.config/lighthouse
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp lighthouse $out/bin
    chmod +x config/lighthouse/cmd*
    chmod +x config/lighthouse/google.py
    patchShebangs config/lighthouse/
    patchShebangs config/lighthouse/scripts/
    mkdir -p $out/share/lighthouse/.config
    cp -r config/lighthouse $out/share/lighthouse/.config
    echo "${lighthouseInstaller}" > $out/bin/lighthouse-install
    chmod +x $out/bin/lighthouse-install
  '';

  meta = with stdenv.lib; {
    description = "A simple flexible popup dialog to run on X";
    homepage = https://github.com/emgram769/lighthouse;
    license = licenses.mit;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = platforms.linux;
  };

}
