{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-02-04";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "963c657c2f852d96b5f203fbb6fafe6c56197ac9";
    hash = "sha256-TNvAonMoGpJXjrkBFrBlYoTlwdPEMwiF/YhsOTYEB4k=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
