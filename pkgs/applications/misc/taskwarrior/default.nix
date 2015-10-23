{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskwarrior-${version}";
  version = "2.5.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "0dj66c4pwdmfnzdlm1r23gqim6banycyzvmq266114v9b90ng3jd";
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
