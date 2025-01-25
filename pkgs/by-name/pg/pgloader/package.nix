{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  sbcl,
  sqlite,
  freetds,
  libzip,
  curl,
  git,
  cacert,
  openssl,
}:
stdenv.mkDerivation rec {
  pname = "pgloader";
  version = "3.6.9";

  src = fetchurl {
    url = "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz";
    sha256 = "sha256-pdCcRmoJnrfVnkhbT0WqLrRbCtOEmRgGRsXK+3uByeA=";
  };

  nativeBuildInputs = [
    git
    makeWrapper
  ];
  buildInputs = [
    sbcl
    cacert
    sqlite
    freetds
    libzip
    curl
    openssl
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    sqlite
    libzip
    curl
    git
    openssl
    freetds
  ];

  buildPhase = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR

    make pgloader
  '';

  dontStrip = true;
  enableParallelBuilding = false;

  installPhase = ''
    install -Dm755 bin/pgloader "$out/bin/pgloader"
    wrapProgram $out/bin/pgloader --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
  '';

  meta = with lib; {
    homepage = "https://pgloader.io/";
    description = "Loads data into PostgreSQL and allows you to implement Continuous Migration from your current database to PostgreSQL";
    mainProgram = "pgloader";
    maintainers = with maintainers; [ mguentner ];
    license = licenses.postgresql;
    platforms = platforms.all;
  };
}
