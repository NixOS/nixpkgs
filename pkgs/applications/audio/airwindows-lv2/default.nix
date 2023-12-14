{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, lv2 }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "26.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CmNe70ii3WfQ6GGHVqTEyQ2HVubzoeoeN3JsCZSbsPM=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ lv2 ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
