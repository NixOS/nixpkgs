{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bslizr";
  version = "1.2.16";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BSlizr";
    tag = version;
    sha256 = "sha256-5DvVkTz79CLvZMZ3XnI0COIfxnhERDSvzbVoJAcqNRI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjaehn/BSlizr";
    description = "Sequenced audio slicing effect LV2 plugin (step sequencer effect)";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
