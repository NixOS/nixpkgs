{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  libtool,
  pkg-config,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdnet";
  version = "1.18.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofalk";
    repo = "libdnet";
    tag = "libdnet-${finalAttrs.version}";
    hash = "sha256-oPlBQB9e8vGJ/rVydMqsZqdInhrpm2sNWkDl9JkkXCI=";
  };

  nativeBuildInputs = [
    automake
    autoconf
    pkg-config
  ];
  buildInputs = [
    check
    libtool
  ];

  # .so endings are missing (quick and dirty fix)
  postInstall = ''
    for i in $out/lib/*; do
      ln -s $i $i.so
    done
  '';

  meta = with lib; {
    description = "Provides a simplified, portable interface to several low-level networking routines";
    homepage = "https://github.com/dugsong/libdnet";
    license = licenses.bsd3;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
})
