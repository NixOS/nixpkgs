{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  autoreconfHook,
  flex,
}:
let
  rev = "b17ea39dc17e5514f33b3f5c34ede92bd16e208c";
in
stdenv.mkDerivation rec {
  pname = "mmh";
  version = "unstable-2020-08-21";

  src = fetchurl {
    url = "http://git.marmaro.de/?p=mmh;a=snapshot;h=${rev};sf=tgz";
    name = "mmh-${rev}.tgz";
    sha256 = "1bqfxafw4l2y46pnsxgy4ji1xlyifzw01k1ykbsjj9p61q3nv6l6";
  };

  postPatch = ''
    substituteInPlace sbr/Makefile.in \
      --replace "ar " "${stdenv.cc.targetPrefix}ar "
  '';

  buildInputs = [ ncurses ];
  nativeBuildInputs = [
    autoreconfHook
    flex
  ];

  meta = with lib; {
    description = "Set of electronic mail handling programs";
    homepage = "http://marmaro.de/prog/mmh";
    license = licenses.bsd3;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ kaction ];
  };
}
