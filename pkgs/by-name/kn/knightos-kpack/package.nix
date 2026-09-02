{
  lib,
  stdenv,
  fetchFromGitHub,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpack";

  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kpack";
    rev = finalAttrs.version;
    sha256 = "sha256-QIi960hlS+aE3DRMtHOndWlehVfD59ybAaO/Dl/qiyQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ scdoc ];

  hardeningDisable = [ "fortify" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://knightos.org/";
    description = "Tool to create or extract KnightOS packages";
    mainProgram = "kpack";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
