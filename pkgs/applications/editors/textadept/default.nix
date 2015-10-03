{stdenv, fetchhg, fetchurl, fetchzip, gtk, glib, pkgconfig, unzip, ncurses, zip}:
let
  buildInputs = [
    gtk glib pkgconfig unzip ncurses zip
  ];
  cached_url = url: sha256: fetchurl {
    inherit sha256 url;
  };
  get_url = url: sha256: ''
    cp ${(cached_url url sha256)} $(basename ${(cached_url url sha256)} | sed -e 's@^[0-9a-z]\+-@@')
    touch $(basename ${(cached_url url sha256)} | sed -e 's@^[0-9a-z]\+-@@')
  '';
  cached_url_zip = url: sha256: fetchzip {
    inherit sha256 url;
  };
  get_url_zip = url: sha256: let zipdir = (cached_url_zip url sha256); in ''
    ( d=$PWD; cd $TMPDIR; name=$(basename ${zipdir} .zip | sed -e 's/^[a-z0-9]*-//'); 
      cp -r ${zipdir} $name; chmod u+rwX -R $name; zip -r $d/$name.zip $name )
    touch $name
  '';
in
stdenv.mkDerivation rec{
  version = "8.2";
  scintillua_version = "3.6.0-1";
  name = "textadept-${version}";
  inherit buildInputs;
  src = fetchhg {
    url = http://foicica.com/hg/textadept;
    rev = "textadept_${version}";
    sha256 = "1vb6a15fyk7ixcv5fy0g400lxbj6dp5ndbmyx53d28idbdkz9ap1";
  };
  preConfigure = ''
    cd src
    mkdir wget
    echo '#! ${stdenv.shell}' > wget/wget
    chmod a+x wget/wget
    export PATH="$PATH:$PWD/wget"
    ${get_url http://prdownloads.sourceforge.net/scintilla/scintilla360.tgz "07ib4w3n9kqfaia2yngj2q7ab5r55zn0hccfzph6vas9hl8vk9zf"}
    ${get_url http://foicica.com/scinterm/download/scinterm_1.6.zip "0ixwj9il6ri1xl4nvb6f108z4qhrahysza6frbbaqmbdz21hnmcl"}
    ${get_url http://foicica.com/scintillua/download/scintillua_3.6.0-1.zip "0zk1ciyyi0d3dz4dzzq5fa74505pvqf0w5yszl7l29c1l4hkk561"}
    ${get_url http://www.lua.org/ftp/lua-5.3.1.tar.gz "05xczy5ws6d7ic3f9h9djwg983bpa4pmds3698264bncssm6f9q7"}
    ${get_url http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-0.12.2.tar.gz "01002avq90yc8rgxa5z9a1768jm054iid3pnfpywdcfij45jgbba"}
    ${get_url_zip http://github.com/keplerproject/luafilesystem/archive/v_1_6_3.zip "1hxcnqj53540ysyw8fzax7f09pl98b8f55s712gsglcdxp2g2pri"}
    ${get_url http://foicica.com/lspawn/download/lspawn_1.2.zip "1fhfi274bxlsdvva5q5j0wv8hx68cmf3vnv9spllzad4jdvz82xv"}
    ${get_url http://luajit.org/download/LuaJIT-2.0.3.tar.gz "0ydxpqkmsn2c341j4r2v6r5r0ig3kbwv3i9jran3iv81s6r6rgjm"}
    ${get_url http://foicica.com/gtdialog/download/gtdialog_1.2.zip "0nvcldyhj8abr8jny9pbyfjwg8qfp9f2h508vjmrvr5c5fqdbbm0"}
    ${get_url ftp://invisible-island.net/cdk/cdk-5.0-20150928.tgz "028da75d5f777a1c4184f88e34918bd273bd83bbe3c959bc11710c4f0ea2e448"}
    mv cdk-*.tgz cdk.tar.gz
    ${get_url_zip http://foicica.com/hg/bombay/archive/d704272c3629.zip "19dg3ky87rfy0a3319vmv18hgn9spplpznvlqnk3djh239ddpplw"}
    mv d704*.zip bombay.zip
    ${get_url http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.17.tar.gz "12gkrv1ldwk945qbpprnyawh0jz7rmqh18fyndbxiajyxmj97538"}
    make deps
  '';
  postBuild = ''
    make curses
  '';
  postInstall = ''
    make curses install PREFIX=$out MAKECMDGOALS=curses
  '';
  makeFlags = ["PREFIX=$(out)"];
  meta = {
    inherit version;
    description = "An extensible text editor based on Scintilla with Lua scripting";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://foicica.com/textadept";
  };
}
