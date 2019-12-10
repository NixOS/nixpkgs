{ lib, fetchFromGitHub }:
rec {
  version = "8.1.2407";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1h23lncm8py0ip8p61y8hivmnd8fzf8xpwpkd73d3a3fpiyd2yx8";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "fortify" ];

  postPatch =
    # Use man from $PATH; escape sequences are still problematic.
    ''
      substituteInPlace runtime/ftplugin/man.vim \
        --replace "/usr/bin/man " "man "
    '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license     = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
