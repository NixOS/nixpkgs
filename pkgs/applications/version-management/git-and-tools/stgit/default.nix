{ stdenv, fetchurl, python, git }:

let
  name = "stgit-0.16";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://download.gna.org/stgit/${name}.tar.gz";
    sha256 = "0hla6401g2kicaakz4awk67yf8fhqbw1shn1p9ma5x6ca29s3w82";
  };

  buildInputs = [ python git ];

  makeFlags = "prefix=$$out";

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d/"
    ln -s ../../share/stgit/completion/stgit-completion.bash "$out/etc/bash_completion.d/"
  '';

  doCheck = false;
  checkTarget = "test";

  meta = {
    homepage = "http://procode.org/stgit/";
    description = "StGit is a patch manager implemented on top of Git";
    license = "GPL";

    maintainers = with stdenv.lib.maintainers; [ simons the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
