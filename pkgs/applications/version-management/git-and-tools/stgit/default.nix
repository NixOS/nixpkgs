{ stdenv, fetchurl, python, git }:

let
  name = "stgit-0.15";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://download.gna.org/stgit/${name}.tar.gz";
    sha256 = "0kgq9x0i7riwcl1lmmm40z0jiz5agr1kqxm2byv1qsf0q1ny47v9";
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

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
