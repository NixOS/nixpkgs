{ lib, stdenv, fetchFromGitHub, libX11, cairo, lv2, pkg-config, libsndfile }:

stdenv.mkDerivation rec {
  pname = "BJumblr";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "1nbxi54023vck3qgmr385cjzinmdnvz62ywb6bcksmc3shl080mg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BJumblr";
    description = "Pattern-controlled audio stream / sample re-sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
