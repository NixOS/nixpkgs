{ stdenv, fetchhg, fetchurl, fetchzip, gtk2, glib, pkgconfig, unzip, ncurses, zip }:
let
  # Textadept requires a whole bunch of external dependencies.
  # The build system expects to be able to download them with wget.
  # This expression gets Nix to fetch them instead.


  cached_url = url: sha256: fetchurl {
    inherit sha256 url;
  };

  get_url = url: sha256: let
    store_path = cached_url url sha256;
  in ''
    local_path=$(basename ${store_path} | sed -e 's@^[0-9a-z]\+-@@')

    # Copy the file from the Nix store and remove the hash part.
    cp ${store_path} $local_path

    # Update its access and modified times.
    touch $local_path
  '';

  cached_url_zip = url: sha256: fetchzip {
    inherit sha256 url;
  };

  get_url_zip = url: sha256: let
    store_path = cached_url_zip url sha256;
  in ''
    (
      build_dir=$PWD
      cd $TMPDIR

      local_path=$(basename ${url} .zip)

      cp -r ${store_path} $local_path
      chmod u+rwX -R $local_path
      zip -r $build_dir/$local_path.zip $local_path
      touch $local_path
    )
  '';


  # These lists are taken from the Makefile.
  scintilla_tgz  = "scintilla373.tgz";
  tre_zip        = "cdce45e8dd7a3b36954022b4a4d3570e1ac5a4f8.zip";
  scinterm_zip   = "scinterm_1.8.zip";
  scintillua_zip = "33298b6cbce3.zip";
  lua_tgz        = "lua-5.3.4.tar.gz";
  lpeg_tgz       = "lpeg-1.0.0.tar.gz";
  lfs_zip        = "v_1_6_3.zip";
  lspawn_zip     = "lspawn_1.5.zip";
  luajit_tgz     = "LuaJIT-2.0.3.tar.gz";
  libluajit_tgz  = "libluajit_2.0.3.x86_64.tgz";
  gtdialog_zip   = "gtdialog_1.3.zip";
  cdk_tgz        = "cdk-5.0-20150928.tgz";
  termkey_tgz    = "libtermkey-0.17.tar.gz";

  scinterm_url   = "http://foicica.com/scinterm/download/" + scinterm_zip;
  tre_url        = "https://github.com/laurikari/tre/archive/" + tre_zip;
  #scintillua_url = "http://foicica.com/scintillua/download/" + scintillua_zip;
  scintillua_url = "http://foicica.com/hg/scintillua/archive/" + scintillua_zip;
  gtdialog_url   = "http://foicica.com/gtdialog/download/" + gtdialog_zip;
  lspawn_url     = "http://foicica.com/lspawn/download/" + lspawn_zip;

  scintilla_url  = "mirror://sourceforge/scintilla/" + scintilla_tgz;
  lua_url        = "http://www.lua.org/ftp/" + lua_tgz;
  lpeg_url       = "http://www.inf.puc-rio.br/~roberto/lpeg/" + lpeg_tgz;
  lfs_url        = "https://github.com/keplerproject/luafilesystem/archive/" + lfs_zip;
  luajit_url     = "http://luajit.org/download/" + luajit_tgz;
  libluajit_url  = "http://foicica.com/textadept/download/" + libluajit_tgz;
  cdk_url        = "http://invisible-mirror.net/archives/cdk/" + cdk_tgz;
  bombay_url     = "http://foicica.com/hg/bombay/archive/tip.zip";
  termkey_url    = "http://www.leonerd.org.uk/code/libtermkey/" + termkey_tgz;


  get_scintilla   = get_url scintilla_url   "0rkczxzj6bqxks4jcbxbyrarjhfjh95nwxxiqprfid1kaamgkfm2";
  get_tre         = get_url tre_url         "0mw8npwk5nnhc33352j4akannhpx77kqvfam8jdq1n4yf8js1gi7";
  get_scinterm    = get_url scinterm_url    "02ax6cjpxylfz7iqp1cjmsl323in066a38yklmsyzdl3w7761nxi";
  get_scintillua  = get_url scintillua_url  "1kx113dpjby1p9jcsqlnlzwj01z94f9szw4b38077qav3bj4lk6g";
  get_lua         = get_url lua_url         "0320a8dg3aci4hxla380dx1ifkw8gj4gbw5c4dz41g1kh98sm0gn";
  get_lpeg        = get_url lpeg_url        "13mz18s359wlkwm9d9iqlyyrrwjc6iqfpa99ai0icam2b3khl68h";
  get_lfs         = get_url_zip lfs_url     "1hxcnqj53540ysyw8fzax7f09pl98b8f55s712gsglcdxp2g2pri";
  get_lspawn      = get_url lspawn_url      "09c6v9irblay2kv1n7i59pyj9g4xb43c6rfa7ba5m353lymcwwqi";
  get_luajit      = get_url luajit_url      "0ydxpqkmsn2c341j4r2v6r5r0ig3kbwv3i9jran3iv81s6r6rgjm";
  get_libluajit   = get_url libluajit_url   "1nhvcdjpqrhd5qbihdm3bxpw84irfvnw2vmfqnsy253ay3dxzrgy";
  get_gtdialog    = get_url gtdialog_url    "0nvcldyhj8abr8jny9pbyfjwg8qfp9f2h508vjmrvr5c5fqdbbm0";
  get_cdk         = get_url cdk_url         "0j74l874y33i26y5kjg3pf1vswyjif8k93pqhi0iqykpbxfsg382";
  get_bombay      = get_url_zip bombay_url  "0illabngrrxidkprgz268wgjqknrds34nhm6hav95xc1nmsdr6jj"
    + "mv tip.zip bombay.zip\n";
  get_termkey     = get_url termkey_url     "12gkrv1ldwk945qbpprnyawh0jz7rmqh18fyndbxiajyxmj97538";


  get_deps = get_scintilla
    + get_tre
    + get_scinterm
    + get_scintillua
    + get_lua
    + get_lpeg
    + get_lfs
    + get_lspawn
    + get_luajit
    + get_libluajit
    + get_gtdialog
    + get_cdk
    + get_bombay
    + get_termkey;
in
stdenv.mkDerivation rec {
  version = "9.3";
  name = "textadept-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2 glib unzip ncurses zip
  ];

  src = fetchhg {
    url = http://foicica.com/hg/textadept;
    rev = "textadept_${version}";
    sha256 = "18x79pazm86agn1khdxfnf87la6kli3xasi7dcjx7l6yyz19y14d";
  };

  preConfigure = ''
    cd src

    # Make a dummy wget.
    mkdir wget
    echo '#! ${stdenv.shell}' > wget/wget
    chmod a+x wget/wget
    export PATH="$PATH:$PWD/wget"

    ${get_deps}

    # Let the build system do whatever setup it needs to do with these files.
    make deps
  '';

  postBuild = ''
    make curses
  '';

  postInstall = ''
    make curses install PREFIX=$out MAKECMDGOALS=curses
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting";
    homepage = http://foicica.com/textadept;
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}
