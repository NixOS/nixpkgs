{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ratools";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "danrl";
    repo = "ratools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mCv+9n8GS1BIfnHuDGN53Y5zMR+CxV5hdOt9muwqpB4=";
  };

  makeFlags = [
    "-C"
    "src"
  ];

  installPhase = ''
    install -vD bin/* -t $out/bin
    install -vD man/* -t $out/share/man/man8
  '';

  meta = {
    description = "Fast, dynamic, multi-threading framework for IPv6 Router Advertisements";
    homepage = "https://github.com/danrl/ratools";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fpletz ];
  };
})
