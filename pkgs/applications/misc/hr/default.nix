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

  dontBuild = true;
  installFlags = [ "PREFIX=$(out)" "MANPREFIX=$(out)/share" ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/LuRsT/hr;
    description = "A horizontal bar for your terminal";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
