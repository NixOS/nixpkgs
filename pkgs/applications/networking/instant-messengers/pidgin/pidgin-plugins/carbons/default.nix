{
  lib,
  stdenv,
  libxml2,
  pidgin,
  pkg-config,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-carbons";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "gkdr";
    repo = "carbons";
    rev = "v${version}";
    sha256 = "sha256-qiyIvmJbRmCrAi/93UxDVtO76nSdtzUVfT/sZGxxAh8=";
  };

  makeFlags = [ "PURPLE_PLUGIN_DIR=$(out)/lib/pidgin" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxml2
    pidgin
  ];

  meta = with lib; {
    homepage = "https://github.com/gkdr/carbons";
    description = "XEP-0280: Message Carbons plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
