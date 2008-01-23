{stdenv, fetchurl, ghc, X11, xmessage}:

stdenv.mkDerivation (rec {

  pname = "xmonad";
  version = "0.5";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${name}.tar.gz";
    sha256 = "cfcc4501b000fa740ed35a5be87dc01216e036219551630dcf71d9c3cf57e4c4";
  };

  buildInputs = [ghc X11];

  meta = {
    description = "xmonad is a tiling window manager for X";
  };

  configurePhase = '' 
    sed -i 's|"xmessage"|"${xmessage}/bin/xmessage"|' XMonad/Core.hs
    ghc --make Setup.lhs
    ./Setup configure --prefix="$out"
  '';

  buildPhase = ''
    ./Setup build
  '';

  installPhase = ''
    ./Setup copy
    ./Setup register --gen-script
    mkdir $out/nix-support
    sed -i 's/|.*\(ghc-pkg update\)/| \1/' register.sh
    cp register.sh $out/nix-support/register-ghclib.sh
    sed -i 's/\(ghc-pkg update\)/\1 --user/' register.sh
    mkdir -p $out/bin
    cp register.sh $out/bin/register-ghclib-${name}.sh
  '';

})
