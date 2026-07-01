{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libschrift";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "tomolt";
    repo = "libschrift";
    rev = "v" + finalAttrs.version;
    sha256 = "01hgvkcb46kr9jzc4ah0js0jy9kr0ll18j2k0c5zil55l3a9rqw1";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
  '';

  makeFlags = [ "libschrift.a" ];

  meta = {
    homepage = "https://github.com/tomolt/libschrift";
    description = "Lightweight TrueType font rendering library";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
