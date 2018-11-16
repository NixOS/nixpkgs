{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  name = "aacgain-1.9.0";

  src = fetchFromGitHub {
    owner = "mulx";
    repo = "aacgain";
    rev = "7c29dccd878ade1301710959aeebe87a8f0828f5";
    sha256 = "07hl432vsscqg01b6wr99qmsj4gbx0i02x4k565432y6zpfmaxm0";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    (
      cd mp4v2
      patch -p0 < ${fetchpatch {
        name = "fix_missing_ptr_deref.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_missing_ptr_deref.patch?h=aacgain-cvs&id=e1a19c920f57063e64bab75cb0d8624731f6e3d7";
        sha256 = "1cq7r005nvmwdjb25z80grcam7jv6k57jnl2bh349mg3ajmslbq9";
      }}
    )
  '';

  configurePhase = ''
    runHook preConfigure
    cd mp4v2
    ./configure

    cd ../faad2
    ./configure

    cd ..
    ./configure
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd mp4v2
    make libmp4v2.la

    cd ../faad2
    make LDFLAGS=-static

    cd ..
    make
    runHook postBuild
  '';

  installPhase = ''
    install -D aacgain/aacgain "$out/bin/aacgain"
  '';

  meta = with stdenv.lib; {
    description = "ReplayGain for AAC files";
    homepage = https://github.com/mulx/aacgain;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.robbinch ];
  };
}
