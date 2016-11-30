{ lib, fetchFromGitHub, fetchpatch }:
rec {
  version = "7.4.2367";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "1r3a3sh1v4q2mc98j2izz9c5qc1a97vy49nv6644la0z2m92vyik";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "fortify" ];

  postPatch =
    # Use man from $PATH; escape sequences are still problematic.
    ''
      substituteInPlace runtime/ftplugin/man.vim \
        --replace "/usr/bin/man " "man "

      patch -p1 < '${
        fetchpatch {
          name = "cve-2016-1248.diff";
          url = "https://github.com/vim/vim/commit/d0b5138b.diff";
          sha256 = "057kg95ipjdirbkr082wbwrbz5l79mwxir8ymkxhma6l6wbxidif";
        }
      }'
    '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license     = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
