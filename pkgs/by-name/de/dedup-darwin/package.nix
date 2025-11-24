{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dedup-darwin";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "ttkb-oss";
    repo = "dedup";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-/qVrZVSVJPANMuKphbekB4p4ehjrOg6097yvjdIdl7I=";
  };

  patches = [
    ./build-date-fix.patch
    ./no-codesign.patch
  ];

  postPatch = ''
    # Fix the prefix
    substituteInPlace Makefile --replace-fail \
      "PREFIX ?= /usr/local" "PREFIX ?= ${placeholder "out"}"
  '';

  preInstall = ''
    # Install complains of missing directories, hence this fix.
    mkdir -p $out/{bin,share/man/man1}
  '';

  meta = {
    description = "Darwin utility to replace duplicate file data with a copy-on-write clone";
    homepage = "https://github.com/ttkb-oss/dedup";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.matteopacini ];
    platforms = lib.platforms.darwin;
    mainProgram = "dedup";
  };
})
