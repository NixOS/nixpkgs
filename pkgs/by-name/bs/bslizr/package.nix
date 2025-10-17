{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
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
    xorg.libX11
    cairo
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BSlizr";
    description = "Sequenced audio slicing effect LV2 plugin (step sequencer effect)";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
