{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "guff";
    rev = "v${finalAttrs.version}";
    sha256 = "0n8mc9j3044j4b3vgc94ryd2j9ik6g73fqja54yxfdfrks4ksyds";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = {
    description = "Plot device";
    homepage = "https://github.com/silentbicycle/guff";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "guff";
  };
})
