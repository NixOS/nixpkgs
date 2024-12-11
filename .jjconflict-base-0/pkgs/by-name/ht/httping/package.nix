{
  cmake,
  fetchFromGitHub,
  fftw,
  gettext,
  lib,
  libintl,
  ncurses,
  nix-update-script,
  openssl,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httping";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "HTTPing";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6PXus8lg+2L9RoRe4nPI1+2iYDKKEhVfJJZMoKWSCb0=";
  };

  nativeBuildInputs = [
    cmake
    gettext
  ];

  buildInputs = [
    fftw
    libintl
    ncurses
    openssl
  ];

  installPhase = ''
    runHook preInstall
    install -D httping $out/bin/httping
    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/folkertvanheusden/HTTPing/releases/tag/v${finalAttrs.version}";
    description = "Ping with HTTP requests";
    homepage = "https://vanheusden.com/httping";
    license = lib.licenses.agpl3Only;
    longDescription = ''
      Give httping an url, and it'll show you how long it takes to connect,
      send a request and retrieve the reply (only the headers). Be aware that
      the transmission across the network also takes time! So it measures the
      latency of the webserver + network. It supports IPv6.
    '';
    mainProgram = "httping";
    maintainers = [ lib.maintainers.anthonyroussel ];
    platforms = lib.platforms.linux;
  };
})
