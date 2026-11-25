{
  lib,
  stdenv,
  fetchFromGitLab,
  gfortran,
  zlib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "millepede-ii";
  version = "04-17-06";

  src = fetchFromGitLab {
    domain = "gitlab.desy.de";
    owner = "claus.kleinwort";
    repo = "millepede-ii";
    tag = "V${finalAttrs.version}";
    hash = "sha256-bcJQHcR6qfLsZTYOgWAeZzJKPo5mH1vq9PFlTowJ/Zs=";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { rev-prefix = "V"; };

  meta = {
    description = "Package for linear least squares fits with a large number of parameters";
    homepage = "https://gitlab.desy.de/claus.kleinwort/millepede-ii";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
})
