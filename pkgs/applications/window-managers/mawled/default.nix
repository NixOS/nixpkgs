{ stdenv, fetchFromGitHub, dale, libX11 }:

let version = "20170517";

in stdenv.mkDerivation {
  name = "mawled-${version}";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "mawled";
    rev = "d8e9714cf1d4b739ceeb4ed16b8adf1dccc12484";
    sha256 = "0py00lgw0cj9c9lvxqc0852g7mvhz2gjp4x0dybwyfcb8kj5nc0w";
  };

  buildInputs = [ dale libX11 ];

  postPatch = ''
    substituteInPlace ./Makefile --replace /usr/local $out
  '';

  hardeningDisable = "bindnow";  # Dale utilizes RTLD_LAZY dlopen flag

  meta = with stdenv.lib; {
    description = "A minimalist window manager written in Dale";
    longDescription = ''
      Mawled is a basic X11 tiling window manager,
      inspired by XMonad, though with fewer features.
    '';
    homepage = "https://github.com/tomhrr/mawled";
    license = licenses.bsd3;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ];
    # The Dale port is currently present only on these platforms
  };
}
