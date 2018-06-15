{ stdenv, fetchurl, python2, git }:

let
  name = "stgit-${version}";
  version = "0.18";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://github.com/ctmarinas/stgit/archive/v${version}.tar.gz";
    sha256 = "19fk6vw3pgp2a98wpd4j3kyiyll5dy9bi4921wq1mrky0l53mj00";
  };

  buildInputs = [ python2 git ];

  makeFlags = "prefix=$$out";

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d/"
    ln -s ../../share/stgit/completion/stgit-completion.bash "$out/etc/bash_completion.d/"
  '';

  doCheck = false;
  checkTarget = "test";

  meta = {
    homepage = http://procode.org/stgit/;
    description = "A patch manager implemented on top of Git";
    license = "GPL";

    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
