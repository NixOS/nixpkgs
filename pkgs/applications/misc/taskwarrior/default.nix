{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.5.1";

  src = fetchurl {
    url = "https://taskwarrior.org/download/task-${version}.tar.gz";
    sha256 = "059a9yc58wcicc6xxsjh1ph7k2yrag0spsahp1wqmsq6h7jwwyyq";
  };

  patches = [ ./0001-bash-completion-quote-pattern-argument-to-grep.patch ];

  nativeBuildInputs = [ cmake libuuid gnutls ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
    mkdir -p "$out/share/fish/vendor_completions.d"
    ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
    mkdir -p "$out/share/zsh/site-functions"
    ln -s "../../../share/doc/task/scripts/zsh/_task" "$out/share/zsh/site-functions/"
  '';

  meta = with stdenv.lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = https://taskwarrior.org;
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
