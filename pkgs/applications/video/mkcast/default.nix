{ stdenv, fetchFromGitHub, wmctrl, pythonPackages, byzanz
, xdpyinfo, makeWrapper, gtk2, xorg, gnome3 }:

stdenv.mkDerivation rec {
  name = "mkcast-2015-03-13";

  src = fetchFromGitHub {
    owner = "KeyboardFire";
    repo = "mkcast";
    rev = "cac22cb6c6f8ec2006339698af5e9199331759e0";
    sha256 = "15wp3n3z8gw7kjdxs4ahda17n844awhxsqbql5ipsdhqfxah2d8p";
  };

  buildInputs = with pythonPackages; [ makeWrapper pygtk gtk2 xlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    for f in $out/bin/*; do #*/
      wrapProgram $f --prefix PATH : "${stdenv.lib.makeBinPath [ xdpyinfo wmctrl byzanz gnome3.gnome_terminal ]}:$out/bin"
    done

    rm -r screenkey/.bzr
    cp -R screenkey $out/bin

    wrapProgram $out/bin/screenkey/screenkey \
      --prefix PATH : "${xorg.xmodmap}/bin"\
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    description = "A tool for creating GIF screencasts of a terminal, with key presses overlaid";
    homepage = https://github.com/KeyboardFire/mkcast;
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar pSub ];
  };
}
