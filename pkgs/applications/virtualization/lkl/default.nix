{ stdenv, fetchFromGitHub, bc, python, fuse, libarchive }:

stdenv.mkDerivation rec {
  name = "lkl-${stdenv.lib.substring 0 7 rev}";
  rev  = "8a0fc49c2d13d5ae5e591d859d78035c368469b0";

  buildInputs = [ bc python fuse libarchive ];

  src = fetchFromGitHub {
    inherit rev;
    owner  = "copumpkin"; # TODO: use 'lkl' here once https://github.com/lkl/linux/pull/294 is merged
    repo   = "linux";
    sha256 = "07k1mq25a907l1ivlgwxycx2vc0fmir3da4xrjkj2v87c7siqvwf";
  };

  installPhase = ''
    mkdir -p $out/{bin,lib}

    # This tool assumes a different directory structure so let's point it at the right location
    cp tools/lkl/bin/lkl-hijack.sh $out/bin
    substituteInPlace $out/bin/lkl-hijack.sh --replace '/../' '/../lib'

    cp tools/lkl/{cptofs,cpfromfs,fs2tar,lklfuse} $out/bin
    cp -r tools/lkl/include $out
    cp tools/lkl/liblkl*.{a,so} $out/lib
  '';

  # We turn off format and fortify because of these errors (fortify implies -O2, which breaks the jitter entropy code):
  #   fs/xfs/xfs_log_recover.c:2575:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #   crypto/jitterentropy.c:54:3: error: #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
  hardeningDisable = [ "format" "fortify" ];

  makeFlags = "-C tools/lkl";

  enableParallelBuilds = true;

  meta = with stdenv.lib; {
    description = "LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as extensively as possible with minimal effort and reduced maintenance overhead";
    platforms   = platforms.linux; # Darwin probably works too but I haven't tested it
    license     = licenses.gpl2;
    maintainers = with maintainers; [ copumpkin ];
  };
}
