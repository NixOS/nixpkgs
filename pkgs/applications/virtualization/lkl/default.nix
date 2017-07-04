{ stdenv, fetchFromGitHub, bc, python, fuse, libarchive }:

stdenv.mkDerivation rec {
  name = "lkl-2017-06-27";
  rev  = "0d91d102b046eec535a6d67df9829b80b24e9ce9";

  outputs = [ "dev" "lib" "out" ];

  nativeBuildInputs = [ bc python ];

  buildInputs = [ fuse libarchive ];

  src = fetchFromGitHub {
    inherit rev;
    owner  = "lkl";
    repo   = "linux";
    sha256 = "1sc18fik2dm0hnsb5q4srvwbf6wgv27zlf3qa7x39g4vbj1jqgas";
  };

  # Fix a /usr/bin/env reference in here that breaks sandboxed builds
  prePatch = "patchShebangs arch/lkl/scripts";

  installPhase = ''
    mkdir -p $out/bin $lib/lib $dev

    cp tools/lkl/bin/lkl-hijack.sh $out/bin
    sed -i $out/bin/lkl-hijack.sh \
        -e "s,LD_LIBRARY_PATH=.*,LD_LIBRARY_PATH=$lib/lib,"

    cp tools/lkl/{cptofs,cpfromfs,fs2tar,lklfuse} $out/bin
    cp -r tools/lkl/include $dev/
    cp tools/lkl/liblkl*.{a,so} $lib/lib
  '';

  # We turn off format and fortify because of these errors (fortify implies -O2, which breaks the jitter entropy code):
  #   fs/xfs/xfs_log_recover.c:2575:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #   crypto/jitterentropy.c:54:3: error: #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
  hardeningDisable = [ "format" "fortify" ];

  makeFlags = "-C tools/lkl";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Linux kernel as a library";
    longDescription = ''
      LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as
      extensively as possible with minimal effort and reduced maintenance
      overhead
    '';
    homepage    = https://github.com/lkl/linux/;
    platforms   = [ "x86_64-linux" ]; # Darwin probably works too but I haven't tested it
    license     = licenses.gpl2;
    maintainers = with maintainers; [ copumpkin ];
  };
}
