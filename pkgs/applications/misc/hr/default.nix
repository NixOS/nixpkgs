{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hr-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "LuRsT";
    repo = "hr";
    rev = version;
    sha256 = "162vkip2772jl59lschpinimpg4ssiyg7fq0va5cx4d7wldpqmks";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    sed -i "s,PREFIX=.*,PREFIX=$out," Makefile
    sed -i "s,MANPREFIX=.*,MANPREFIX=$out/share," Makefile
    make install
  '';

  meta = {
    homepage = https://github.com/LuRsT/hr;
    description = "A horizontal bar for your terminal";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
