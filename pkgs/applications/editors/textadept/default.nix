{ stdenv, fetchhg, fetchurl, fetchzip, gtk, glib, pkgconfig, unzip, ncurses, zip }:
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

      local_path=$(basename ${store_path} .zip | sed -e 's/^[a-z0-9]*-//')

      cp -r ${store_path} $local_path
      chmod u+rwX -R $local_path
      zip -r $build_dir/$local_path.zip $local_path
      touch $local_path
    )
  '';


  # These lists are taken from the Makefile.
  scintilla_tgz  = "scintilla365.tgz";
  scinterm_zip   = "scinterm_1.8.zip";
  scintillua_zip = "scintillua_3.6.5-1.zip";
  lua_tgz        = "lua-5.3.2.tar.gz";
  lpeg_tgz       = "lpeg-1.0.0.tar.gz";
  lfs_zip        = "v_1_6_3.zip";
  luautf8_zip    = "0.1.1.zip";
  lspawn_zip     = "lspawn_1.5.zip";
  luajit_tgz     = "LuaJIT-2.0.3.tar.gz";
  libluajit_tgz  = "libluajit_2.0.3.x86_64.tgz";
  gtdialog_zip   = "gtdialog_1.2.zip";
  cdk_tgz        = "cdk-5.0-20150928.tgz";
  termkey_tgz    = "libtermkey-0.17.tar.gz";
  bombay_zip     = "bombay.zip";

  scinterm_url   = "http://foicica.com/scinterm/download/" + scinterm_zip;
  scintillua_url = "http://foicica.com/scintillua/download/" + scintillua_zip;
  gtdialog_url   = "http://foicica.com/gtdialog/download/" + gtdialog_zip;
  lspawn_url     = "http://foicica.com/lspawn/download/" + lspawn_zip;

  scintilla_url  = "http://prdownloads.sourceforge.net/scintilla/" + scintilla_tgz;
  lua_url        = "http://www.lua.org/ftp/" + lua_tgz;
  lpeg_url       = "http://www.inf.puc-rio.br/~roberto/lpeg/" + lpeg_tgz;
  lfs_url        = "https://github.com/keplerproject/luafilesystem/archive/" + lfs_zip;
  luautf8_url    = "https://github.com/starwing/luautf8/archive/" + luautf8_zip;
  luajit_url     = "http://luajit.org/download/" + luajit_tgz;
  libluajit_url  = "http://foicica.com/textadept/download/" + libluajit_tgz;
  cdk_url        = "http://invisible-mirror.net/archives/cdk/" + cdk_tgz;
  bombay_url     = "http://foicica.com/hg/bombay/archive/tip.zip";
  termkey_url    = "http://www.leonerd.org.uk/code/libtermkey/" + termkey_tgz;


  get_scintilla   = get_url scintilla_url   "1s5zbkn5f3vs8gbnjlkfzw4b137y12m3c89lyc4pmvqvrvxgyalj";
  get_scinterm    = get_url scinterm_url    "02ax6cjpxylfz7iqp1cjmsl323in066a38yklmsyzdl3w7761nxi";
  get_scintillua  = get_url scintillua_url  "0s4q7a9mgvxh0msi18llkczhcgafaiizw9qm1p9w18r2a7wjq9wc";
  get_lua         = get_url lua_url         "13x6knpv5xsli0n2bib7g1nrga2iacy7qfy63i798dm94fxwfh67";
  get_lpeg        = get_url lpeg_url        "13mz18s359wlkwm9d9iqlyyrrwjc6iqfpa99ai0icam2b3khl68h";
  get_lfs         = get_url_zip lfs_url     "1hxcnqj53540ysyw8fzax7f09pl98b8f55s712gsglcdxp2g2pri";
  get_luautf8_zip = get_url_zip luautf8_url "1dgmxdk88njpic4d4sn2wzlni4b6sfqcsmh2hrraxivpqf9ps7f7";
  get_lspawn      = get_url lspawn_url      "09c6v9irblay2kv1n7i59pyj9g4xb43c6rfa7ba5m353lymcwwqi";
  get_luajit      = get_url luajit_url      "0ydxpqkmsn2c341j4r2v6r5r0ig3kbwv3i9jran3iv81s6r6rgjm";
  get_libluajit   = get_url libluajit_url   "1nhvcdjpqrhd5qbihdm3bxpw84irfvnw2vmfqnsy253ay3dxzrgy";
  get_gtdialog    = get_url gtdialog_url    "0nvcldyhj8abr8jny9pbyfjwg8qfp9f2h508vjmrvr5c5fqdbbm0";
  get_cdk         = get_url cdk_url         "0j74l874y33i26y5kjg3pf1vswyjif8k93pqhi0iqykpbxfsg382";
  get_bombay      = get_url_zip bombay_url  "05fnh1imxdb4sb076fzqywqszp31whdbkzmpkqxc8q2r1m5vj3hg"
    + "mv tip.zip bombay.zip\n";
  get_termkey     = get_url termkey_url     "12gkrv1ldwk945qbpprnyawh0jz7rmqh18fyndbxiajyxmj97538";


  get_deps = get_scintilla
    + get_scinterm
    + get_scintillua
    + get_lua
    + get_lpeg
    + get_lfs
    + get_luautf8_zip
    + get_lspawn
    + get_luajit
    + get_libluajit
    + get_gtdialog
    + get_cdk
    + get_bombay
    + get_termkey;
in
stdenv.mkDerivation rec {
  version = "8.7";
  name = "textadept-${version}";

  buildInputs = [
    gtk glib pkgconfig unzip ncurses zip
  ];

  src = fetchhg {
    url = http://foicica.com/hg/textadept;
    rev = "textadept_${version}";
    sha256 = "1gi73wk11w3rbkxqqdp8z9g83qiyhx6gxry221vxjxpqsl9pvhlf";
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
