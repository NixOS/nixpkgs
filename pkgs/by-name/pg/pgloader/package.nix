{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  sbcl,
  sqlite,
  freetds,
  libzip,
  curl,
  git,
  cacert,
  openssl,
  sphinx,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pgloader";
  version = "3.6.9";

  srcs = [
    (fetchurl {
      url = "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz";
      sha256 = "sha256-pdCcRmoJnrfVnkhbT0WqLrRbCtOEmRgGRsXK+3uByeA=";
    })
    # needed because bundle does not contain docs / man pages
    (fetchFromGitHub {
      owner = "dimitri";
      repo = "pgloader";
      rev = "v${finalAttrs.version}";
      hash = "sha256-lqvfWayaJbZ9xx4CgFfY1g0TKwFEd5IWf+RLLXQddw4=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    git
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    sbcl
    cacert
    sqlite
    sphinx
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

    pushd pgloader-bundle-${finalAttrs.version}
    make pgloader
    popd

    pushd source/docs
    make man
    popd
  '';

  dontStrip = true;
  enableParallelBuilding = false;

  installPhase = ''
    install -Dm755 pgloader-bundle-${finalAttrs.version}/bin/pgloader "$out/bin/pgloader"
    wrapProgram $out/bin/pgloader --prefix LD_LIBRARY_PATH : "${finalAttrs.LD_LIBRARY_PATH}"
    mkdir -p $out/bin $out/man/man1
    installManPage source/docs/_build/man/*.1
  '';

  meta = with lib; {
    homepage = "https://pgloader.io/";
    description = "Loads data into PostgreSQL and allows you to implement Continuous Migration from your current database to PostgreSQL";
    mainProgram = "pgloader";
    maintainers = with maintainers; [ mguentner ];
    license = licenses.postgresql;
    platforms = platforms.all;
  };
})
