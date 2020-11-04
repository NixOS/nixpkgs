{ mkDerivation, fetchFromGitHub, cmake, pkg-config, lib,
  qttools, fribidi, libunibreak }:

mkDerivation rec {
  pname = "coolreader";
  version = "3.2.49";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = pname;
    rev = "cr${version}";
    sha256 = "10i3w4zjlilz3smjzbwm50d91ns3w0wlgmsf38fn2lv76zczv8ia";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ qttools fribidi libunibreak ];

  meta = with lib; {
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    license = licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
