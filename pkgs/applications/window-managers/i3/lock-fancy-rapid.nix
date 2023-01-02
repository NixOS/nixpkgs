{ lib, stdenv, fetchFromGitHub, xorg, i3lock }:

stdenv.mkDerivation rec {
  pname = "i3lock-fancy-rapid";
  version = "2019-10-09";
  src = fetchFromGitHub {
    owner = "yvbbrjdr";
    repo = "i3lock-fancy-rapid";
    rev = "c67f09bc8a48798c7c820d7d4749240b10865ce0";
    sha256 = "0jhvlj6v6wx70239pgkjxd42z1s2bzfg886ra6n1rzsdclf4rkc6";
  };

  buildInputs = [ xorg.libX11 ];
  propagatedBuildInputs = [ i3lock ];

  postPatch = ''
    substituteInPlace i3lock-fancy-rapid.c \
      --replace '"i3lock"' '"${i3lock}/bin/i3lock"'
  '';

  installPhase = ''
    install -D i3lock-fancy-rapid $out/bin/i3lock-fancy-rapid
    ln -s $out/bin/i3lock-fancy-rapid $out/bin/i3lock
  '';

  meta = with lib; {
    description = "A faster implementation of i3lock-fancy";
    homepage = "https://github.com/yvbbrjdr/i3lock-fancy-rapid";
    maintainers = with maintainers; [ nickhu ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
