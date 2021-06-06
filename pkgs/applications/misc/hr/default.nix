{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hr";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "LuRsT";
    repo = "hr";
    rev = version;
    sha256 = "068kq37lbqfjzh28rlvkprni38ii991naawylwvq6d43y9dpzs2b";
  };

  dontBuild = true;
  installFlags = [ "PREFIX=$(out)" "MANPREFIX=$(out)/share" ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  meta = with lib; {
    homepage = "https://github.com/LuRsT/hr";
    description = "A horizontal bar for your terminal";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
