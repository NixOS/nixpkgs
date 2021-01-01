{ stdenv, fetchFromGitHub, cmake, tdlib, pidgin, libwebp, libtgvoip } :

stdenv.mkDerivation rec {
  pname = "tdlib-purple";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "ars3niy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1inamfzbrz0sy4y431jgwjfg6lz14a7c71khrg02481raxchhzzf";
  };

  cmakeFlags = [
    "-Dtgvoip_INCLUDE_DIRS=${libtgvoip.dev}/include/tgvoip"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pidgin tdlib libwebp libtgvoip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/purple-2/
    cp *.so $out/lib/purple-2/
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/ars3niy/tdlib-purple";
    description = "New libpurple plugin for Telegram";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.lassulus ];
    platforms = platforms.linux;
  };
}
