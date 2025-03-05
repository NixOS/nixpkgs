{ stdenv, lib, fetchgit, pkg-config, git, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "fileshare";
  version = "0.2.4";

  src = fetchgit {
    url = "https://git.tkolb.de/Public/fileshare.git";
    rev = "v${version}";
    sha256 = "03jrhk4vj6bc2w3lsrfjpfflb4laihysgs5i4cv097nr5cz32hyk";
  };

  postPatch = ''
    sed -i 's,$(shell git rev-parse --short HEAD),/${version},g' Makefile
  '';

  nativeBuildInputs = [ pkg-config git ];
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
