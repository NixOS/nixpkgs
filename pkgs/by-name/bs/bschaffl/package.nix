{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
  libX11,
  lv2,
}:

stdenv.mkDerivation rec {
  pname = "bschaffl";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "sha256-zfhPYH4eUNWHV27ZtX2IIvobyPdKs5yGr/ryJRQa6as=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    libX11
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BSchaffl";
    description = "Pattern-controlled MIDI amp & time stretch LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
