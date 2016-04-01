{ stdenv, fetchurl, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "3.4.8";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "4f818fd09bff89625b4317cc7c05445f6e7bd9ea8d21e7eefeaaca07b8b0cd9f";
  };

  buildInputs = [
     pkgs.boost
     pkgs.openssl
     pkgs.postgresql
     ];

  enableParallelBuilding = true;
  configureFlagsArray = [
    "--with-modules=bind random gpgsql"
    ];
  meta = {
    homepage = https://www.powerdns.com/;
    description = "The PowerDNS Authoritative Server is the only solution that enables authoritative DNS service from all major databases, including but not limited to MySQL, PostgreSQL, SQLite3, Oracle, Sybase, Microsoft SQL Server, LDAP and plain text files.";
  };
}
