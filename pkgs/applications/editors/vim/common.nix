{ lib, fetchFromGitHub }:
rec {
  version = "9.0.1275";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    hash = "sha256-WDnlYi9o2Kv/f3Fh1MHcfTlBTe1fxw4UyKJlKY04fyA=";
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
    homepage    = "http://www.vim.org";
    license     = licenses.vim;
    maintainers = with maintainers; [ das_j equirosa ];
    platforms   = platforms.unix;
  };
}
