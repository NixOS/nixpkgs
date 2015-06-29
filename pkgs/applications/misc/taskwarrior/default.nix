{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskwarrior-${version}";
  version = "2.4.4";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "7ff406414e0be480f91981831507ac255297aab33d8246f98dbfd2b1b2df8e3b";
  };

  nativeBuildInputs = [ cmake libuuid gnutls ];

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d"
    ln -s "../../share/doc/task/scripts/bash/task.sh" "$out/etc/bash_completion.d/"
  '';

  meta = with stdenv.lib; {
    description = "GTD (getting things done) implementation";
    homepage = http://taskwarrior.org;
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber jgeerds ];
    platforms = platforms.linux;
  };
}
