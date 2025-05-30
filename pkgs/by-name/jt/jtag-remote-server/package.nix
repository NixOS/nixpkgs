{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  libftdi1,
}:

stdenv.mkDerivation rec {
  pname = "jtag-remote-server";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "jiegec";
    repo = "jtag-remote-server";
    rev = "v${version}";
    hash = "sha256-qtgO0BO2hvWi/E2RzGTTuQynKbh7/OLeoLcm60dqro8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libftdi1 ];

  meta = with lib; {
    description = "Remote JTAG server for remote debugging";
    mainProgram = "jtag-remote-server";
    homepage = "https://github.com/jiegec/jtag-remote-server";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
