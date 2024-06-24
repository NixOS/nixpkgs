{ lib, stdenv, fetchurl, makeWrapper, unzip, jre, runtimeShell }:

stdenv.mkDerivation rec {
  version = "1.9";
  pname = "msgviewer";
  uname = "MSGViewer";

  src = fetchurl {
    url    = "mirror://sourceforge/msgviewer/${uname}-${version}/${uname}-${version}.zip";
    sha256 = "0igmr8c0757xsc94xlv2470zv2mz57zaj52dwr9wj8agmj23jbjz";
  };

  buildCommand = ''
    dir=$out/lib/msgviewer
    mkdir -p $out/bin $dir
    unzip $src -d $dir
    mv $dir/${uname}-${version}/* $dir
    rmdir $dir/${uname}-${version}
    cat <<_EOF > $out/bin/msgviewer
    #!${runtimeShell} -eu
    exec ${lib.getBin jre}/bin/java -jar $dir/MSGViewer.jar "\$@"
    _EOF
    chmod 755 $out/bin/msgviewer
  '';

  nativeBuildInputs = [ makeWrapper unzip ];

  meta = with lib; {
    description = "Viewer for .msg files (MS Outlook)";
    mainProgram = "msgviewer";
    homepage    = "https://www.washington.edu/alpine/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license     = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
