{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "urxvt-resize-font";
  version = "2019-10-05";
  dontPatchShebangs = true;

  src = fetchFromGitHub {
    owner = "simmel";
    repo = "urxvt-resize-font";
    rev = "e966a5d77264e9263bfc8a51e160fad24055776b";
    sha256 = "18ab3bsfdkzzh1n9fpi2al5bksvv2b7fjmvxpx6fzqcy4bc64vkh";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp resize-font $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "URxvt Perl extension for resizing the font";
    homepage = "https://github.com/simmel/urxvt-resize-font";
    license = licenses.mit;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
