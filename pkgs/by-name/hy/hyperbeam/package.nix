{
  buildNpmPackage,
  lib,
  fetchurl,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hyperbeam";
  version = "3.0.2";

  npmDepsHash = "sha256-ZZX3BOtSSiLvAEcWuKiUMHrYOt8N6SYYQ+QGzbprL3E=";

  dontNpmBuild = true;

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hyperbeam";
    rev = "v${version}";
    hash = "sha256-g3eGuol3g1yfGHDSzI1wQXMxJudGCt4PHHdmtiRQS/Q=";
  };

  patches = [
    # TODO: remove after this is merged: https://github.com/holepunchto/hyperbeam/pull/22
    (fetchurl {
      url = "https://github.com/holepunchto/hyperbeam/commit/e84e4be979bf89d8e8042878d2beb5c1a5dbf946.patch";
      hash = "sha256-AdXmfti9/08kRYuL1l4gXmvSV7bV0kE72Pf/bNqiFQw=";
    })
  ];

  meta = {
    description = "A 1-1 end-to-end encrypted internet pipe powered by Hyperswarm ";
    homepage = "https://github.com/holepunchto/hyperbeam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davhau ];
    mainProgram = "hyperbeam";
    platforms = lib.platforms.all;
  };
}
