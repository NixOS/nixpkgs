{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2023-12-28";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "0b9bf10851d6ad54441dc4f687d5755ed2c6f7a8";
    hash = "sha256-oWEeAhyxFO1TFH3d+/ivRf1KnNUU8y5c/7NtOzlpKXg=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
