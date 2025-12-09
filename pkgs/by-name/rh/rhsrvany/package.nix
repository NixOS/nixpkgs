{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhsrvany";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rwmjones";
    repo = "rhsrvany";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-eeEiAdm7NO5fFYKtHQbeBq4RhP8Xwgw2p2Wkm+n0EWM=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Free equivalent of Windows \"srvany\" program for turning any Windows program or script into a service";
    homepage = "https://github.com/rwmjones/rhsrvany";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lukts30 ];
    platforms = lib.platforms.windows;
  };
})
