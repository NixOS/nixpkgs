{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-01-08";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "0f5500f50e2a5ac7e40e6f5f8aeb160d46348828";
    hash = "sha256-0JHl7myoa3MlfucmbKB5tubJ6sQ2IlTIL3i2yveOvaU=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
