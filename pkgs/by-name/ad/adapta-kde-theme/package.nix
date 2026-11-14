{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adapta-kde-theme";
  version = "20180828";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "adapta-kde";
    tag = finalAttrs.version;
    hash = "sha256-SCbg8DLrBXMpzoEJ9doTRFs22QCnvc2n0BE5p9ExBeE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Port of the Adapta theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/adapta-kde";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.tadfisher ];
    platforms = lib.platforms.all;
  };
})
