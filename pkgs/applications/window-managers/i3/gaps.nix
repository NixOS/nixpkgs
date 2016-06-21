{ fetchurl, stdenv, i3 }:

i3.overrideDerivation (super : rec {

  name = "i3-gaps-${version}";
  version = "4.12";
  releaseDate = "2016-03-06";

  src = fetchurl {
    url = "https://github.com/Airblader/i3/archive/${version}.tar.gz";
    sha256 = "1i9l993cak85fcw12zgrb5cpspmjixr3yf8naa4zb8589mg4rb8s";
  };

  postUnpack = ''
      echo -n "${version} (${releaseDate}, branch \\\"gaps-next\\\")" > ./i3-${version}/I3_VERSION
      echo -n "${version}" > ./i3-${version}/VERSION
  '';

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done
  '';

}) // {

  meta = with stdenv.lib; {
    description = "A fork of the i3 tiling window manager with some additional features";
    homepage    = "https://github.com/Airblader/i3";
    maintainers = with maintainers; [ fmthoma ];
    license     = licenses.bsd3;
    platforms   = platforms.all;

    longDescription = ''
      Fork of i3wm, a tiling window manager primarily targeted at advanced users
      and developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as floating
      windows. This fork adds a few features such as gaps between windows.
      Configured via plain text file. Multi-monitor. UTF-8 clean.
    '';
  };

}
