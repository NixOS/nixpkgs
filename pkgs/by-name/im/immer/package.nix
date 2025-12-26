{
  lib,
  stdenv,
  catch2,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "immer";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "immer";
    tag = "v${version}";
    hash = "sha256-Tyj2mNyLhrcFNQEn4xHC8Gz7/jtA4Dnkjtk8AAXJEw8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    catch2
  ];

  strictDeps = true;

  dontBuild = true;
  dontUseCmakeBuildDir = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Postmodern immutable and persistent data structures for C++ — value semantics at scale";
    homepage = "https://sinusoid.es/immer";
    changelog = "https://github.com/arximboldi/immer/releases/tag/v${version}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
}
