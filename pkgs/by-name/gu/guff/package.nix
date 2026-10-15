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
    hash = "sha256-unk9iZ7ZNdc9KUpiN84zMyYpms8ksbfHIpIQMGRiFVk=";
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
