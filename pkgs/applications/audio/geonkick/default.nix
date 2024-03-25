{ lib, stdenv, fetchFromGitLab, cmake, pkg-config, libsndfile, rapidjson
, libjack2, lv2, libX11, cairo, openssl }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "3.3.1";

  src = fetchFromGitLab {
    owner = "Geonkick-Synthesizer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fsDoqQqZsoeQa66dxb8JC2ywUFmBf6b2J+/ixWZTzfU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libsndfile rapidjson libjack2 lv2 libX11 cairo openssl ];

  # Without this, the lv2 ends up in
  # /nix/store/$HASH/nix/store/$HASH/lib/lv2
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "A free software percussion synthesizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
    mainProgram = "geonkick";
  };
}
