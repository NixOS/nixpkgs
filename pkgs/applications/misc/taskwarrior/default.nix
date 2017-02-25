{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskwarrior-${version}";
  version = "2.5.1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "059a9yc58wcicc6xxsjh1ph7k2yrag0spsahp1wqmsq6h7jwwyyq";
  };

  patches = [ ./0001-bash-completion-quote-pattern-argument-to-grep.patch ];

  nativeBuildInputs = [ cmake libuuid gnutls ];

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d"
    ln -s "../../share/doc/task/scripts/bash/task.sh" "$out/etc/bash_completion.d/"
  '';

  meta = with stdenv.lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = http://taskwarrior.org;
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber jgeerds ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
