{ lib, stdenv, fetchFromGitHub, mozjpeg, makeWrapper, coreutils, parallel, findutils }:

stdenv.mkDerivation {
  pname = "jpeg-archive";
  version = "2.2.0"; # can be found here https://github.com/danielgtaylor/jpeg-archive/blob/master/src/util.c#L15

  # update with
  # nix-prefetch-git https://github.com/danielgtaylor/jpeg-archive
  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "jpeg-archive";
    rev = "8da4bf76b6c3c0e11e4941294bfc1857c119419b";
    sha256 = "1639y9qp2ls80fzimwmwds792q8rq5p6c14c0r4jswx4yp6dcs33";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mozjpeg ];

  prePatch = ''
    # allow override LIBJPEG
    substituteInPlace Makefile --replace 'LIBJPEG =' 'LIBJPEG ?='
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: src/util.o:(.bss+0x0): multiple definition of `progname'; /build/ccBZT2Za.o:(.bss+0x20): first defined here
  # https://github.com/danielgtaylor/jpeg-archive/issues/119
  NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
    "MOZJPEG_PREFIX=${mozjpeg}"
    "LIBJPEG=${mozjpeg}/lib/libjpeg${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  postInstall = ''
    wrapProgram $out/bin/jpeg-archive \
      --set PATH "$out/bin:${coreutils}/bin:${parallel}/bin:${findutils}/bin"
  '';

  meta = with lib; {
    description = "Utilities for archiving photos for saving to long term storage or serving over the web";
    homepage    = "https://github.com/danielgtaylor/jpeg-archive";
    license = licenses.mit;
    maintainers = [ maintainers.srghma ];
    platforms   = platforms.all;
  };
}
