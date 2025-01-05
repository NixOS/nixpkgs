{
  lib,
  stdenv,
  fetchFromGitHub,
  libxslt,
  docbook_xsl,
  postgresql,
}:

stdenv.mkDerivation rec {
  pname = "pg_checksums";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "credativ";
    repo = pname;
    rev = version;
    sha256 = "sha256-joGaCoRMGpEqq7pnT4Qd7XySjZ5wlZPW27WfOv1UFF4=";
  };

  nativeBuildInputs = [ libxslt.bin ];

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
