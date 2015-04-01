{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskwarrior-${version}";
  version = "2.4.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "17hiv7zld06zb5xmyp96bw9xl6vp178fhffs660fxxpxn3srb9bg";
  };

  nativeBuildInputs = [ cmake libuuid gnutls ];

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d"
    ln -s "../../share/doc/task/scripts/bash/task.sh" "$out/etc/bash_completion.d/"
  '';

  meta = {
    description = "GTD (getting things done) implementation";
    homepage = http://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
