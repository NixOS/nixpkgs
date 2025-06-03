{
  stdenv,
  lib,
  fetchFromGitea,
  pkg-config,
  git,
  libmicrohttpd,
}:

stdenv.mkDerivation rec {
  pname = "fileshare";
  version = "0.2.4";

  src = fetchFromGitea {
    domain = "git.tkolb.de";
    owner = "Public";
    repo = "fileshare";
    rev = "v${version}";
    sha256 = "sha256-00MxPivZngQ2I7Hopz2MipJFnbvSZU0HF2wZucmEWQ4=";
  };

  postPatch = ''
    sed -i 's,$(shell git rev-parse --short HEAD),/${version},g' Makefile
    substituteInPlace Makefile \
      --replace-fail pkg-config "${stdenv.cc.targetPrefix}pkg-config" \
      --replace-fail gcc "${stdenv.cc.targetPrefix}cc"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  nativeBuildInputs = [
    pkg-config
    git
  ];
  buildInputs = [ libmicrohttpd ];

  makeFlags = [ "BUILD=release" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release/fileshare $out/bin
  '';

  meta = with lib; {
    description = "Small HTTP Server for quickly sharing files over the network";
    longDescription = "Fileshare is a simple tool for sharing the contents of a directory via a webserver and optionally allowing uploads.";
    homepage = "https://git.tkolb.de/Public/fileshare";
    license = licenses.mit;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
    mainProgram = "fileshare";
  };
}
