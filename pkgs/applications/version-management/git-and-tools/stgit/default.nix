{ stdenv, fetchurl, python, git }:

let
  name = "stgit-0.17.1";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://download.gna.org/stgit/${name}.tar.gz";
    sha256 = "1pka0ns9x0kabn036zsf0mwmwiynckhnva51kgxsch9fqah6acyl";
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
    description = "A patch manager implemented on top of Git";
    license = "GPL";

    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
