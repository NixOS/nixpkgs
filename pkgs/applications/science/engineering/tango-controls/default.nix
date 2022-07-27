{ stdenv, fetchurl, pkg-config, python3, openjdk8, zlib, zeromq, cppzmq, mariadb-connector-c, lib }:
let
  omniorb_4_2 = stdenv.mkDerivation rec {
    pname = "omniorb";
    version = "4.2.5";

    src = fetchurl {
      url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
      sha256 = "1fvkw3pn9i2312n4k3d4s7892m91jynl8g1v2z0j8k1gzfczjp7h";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ python3 ];

    enableParallelBuilding = true;
    hardeningDisable = [ "format" ];
  };
in
stdenv.mkDerivation rec {
  pname = "tango";
  version = "9.3.5";

  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/24125890/packages/generic/TangoSourceDistribution/${version}/${pname}-${version}.tar.gz";
    sha256 = "1i59023gqm6sk000520y4kamfnfa8xqy9xwsnz5ch22nflgqn9px";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib omniorb_4_2 zeromq cppzmq ];

  configureFlags = [
    "--enable-java=yes"
    "--enable-dbserver=yes"
    "--with-java=${openjdk8}/bin/java"
    "--with-mysqlclient-lib=${mariadb-connector-c}/lib/mariadb/"
    "--with-mysqlclient-include=${mariadb-connector-c.dev}/include/mariadb"
  ];

  postInstall = ''
    mkdir -p $out/share/sql
    for fn in cppserver/database/*sql; do
      sed -e "s#^source #source $out/share/sql/#" "$fn" > $out/share/sql/$(basename "$fn")
    done
  '';

  meta = with lib; {
    description = "A free open source device-oriented controls toolkit for controlling any kind of hardware or software and building SCADA systems.";
    homepage = "https://www.tango-controls.org/";
    mainProgram = "tango";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = [ maintainers.pmiddend ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
