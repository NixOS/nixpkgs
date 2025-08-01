{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  expat,
  libmysqlclient,
  enableXmlpipe2 ? false,
  enableMysql ? true,
}:

stdenv.mkDerivation rec {
  pname = "sphinxsearch";
  version = "2.2.11";

  src = fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "1aa1mh32y019j8s3sjzn4vwi0xn83dwgl685jnbgh51k16gh6qk6";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--program-prefix=sphinxsearch-"
    "--enable-id64"
  ]
  ++ lib.optionals (!enableMysql) [
    "--without-mysql"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    lib.optionals enableMysql [
      libmysqlclient
    ]
    ++ lib.optionals enableXmlpipe2 [
      expat
    ];

  CXXFLAGS = "-std=c++98";

  meta = {
    description = "Open source full text search server";
    homepage = "http://sphinxsearch.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ederoyd46
      valodim
    ];
  };
}
