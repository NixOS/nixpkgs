{
  lib,
  clangStdenv,
  fetchFromGitHub,
  libxslt,
  docbook_xsl,
  postgresql,
}:

clangStdenv.mkDerivation rec {
  pname = "pg_checksums";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "credativ";
    repo = "pg_checksums";
    rev = version;
    sha256 = "sha256-iPgiiOxj3EDK7uf0D94oZSGz3RQbK3yEvdKNCW2Q1N0=";
  };

  nativeBuildInputs = [
    libxslt.bin
    postgresql.pg_config
  ];

  buildInputs = [ postgresql ];

  buildFlags = [
    "all"
    "man"
  ];

  preConfigure = ''
    substituteInPlace doc/stylesheet-man.xsl \
      --replace "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
  '';

  installPhase = ''
    install -Dm755 -t $out/bin pg_checksums_ext
    install -Dm644 -t $out/share/man/man1 doc/man1/pg_checksums_ext.1
  '';

  meta = with lib; {
    description = "Activate/deactivate/verify checksums in offline PostgreSQL clusters";
    homepage = "https://github.com/credativ/pg_checksums";
    maintainers = [ ];
    mainProgram = "pg_checksums_ext";
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
