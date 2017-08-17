{ stdenv, fetchurl, makeWrapper, writeScript, unzip, jre }:

let
  version = "1.9";
  name = "msgviewer-${version}";
  uname = "MSGViewer-${version}";

in stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url    = "mirror://sourceforge/msgviewer/${uname}/${uname}.zip";
    sha256 = "0igmr8c0757xsc94xlv2470zv2mz57zaj52dwr9wj8agmj23jbjz";
  };

  buildCommand = ''
    dir=$out/lib/msgviewer
    mkdir -p $out/bin $dir
    unzip $src -d $dir
    mv $dir/${uname}/* $dir
    rmdir $dir/${uname}
    cat <<_EOF > $out/bin/msgviewer
#!${stdenv.shell} -eu
${stdenv.lib.getBin jre}/bin/java -jar $dir/MSGViewer.jar $@
_EOF
    chmod 755 $out/bin/msgviewer
  '';

  nativeBuildInputs = [ makeWrapper unzip ];

  meta = with stdenv.lib; {
    description = "Viewer for .msg files (MS Outlook)";
    homepage    = https://www.washington.edu/alpine/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
