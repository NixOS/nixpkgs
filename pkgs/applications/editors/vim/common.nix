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

  patches = [
    (fetchpatch {
      name = "CVE-2016-1248.diff";
      url = https://github.com/vim/vim/commit/d0b5138b.diff;
      sha256 = "057kg95ipjdirbkr082wbwrbz5l79mwxir8ymkxhma6l6wbxidif";
    })
    (fetchpatch {
      name = "CVE-2017-5953.patch";
      url = https://github.com/vim/vim/commit/399c297aa93afe2c0a39e2a1b3f972aebba44c9d.patch;
      sha256 = "19i2m27czkm9di999nbf5mrvb9dx8w5r5169pakmljg4zzbc61g5";
    })
  ];

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
