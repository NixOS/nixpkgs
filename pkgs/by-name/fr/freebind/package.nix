{
  lib,
  stdenv,
  fetchFromGitHub,
  libnetfilter_queue,
  libnfnetlink,
}:

stdenv.mkDerivation {
  pname = "freebind";
  version = "2017-12-27";

  src = fetchFromGitHub {
    owner = "blechschmidt";
    repo = "freebind";
    rev = "9a13d6f9c12aeea4f6d3513ba2461d34f841f278";
    hash = "sha256-GbPv7q9I6QSnU1g9Z6NFbCdFrAOFK0aQ+Qsinn7sYsc=";
  };

  buildInputs = [
    libnetfilter_queue
    libnfnetlink
  ];

  postPatch = ''
    substituteInPlace preloader.c --replace /usr/local/ $out/
    substituteInPlace Makefile    --replace /usr/local/ $out/
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib
  '';

  meta = {
    description = "IPv4 and IPv6 address rate limiting evasion tool";
    homepage = "https://github.com/blechschmidt/freebind";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
