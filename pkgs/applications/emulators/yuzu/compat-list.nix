{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "a3dd360e8b6e8c0c93d40f00416534c8b4bcd59a";
    hash = "sha256-nXh5cJTS1zCa6GoH+AoisTIohsRruycqosxpmFAsaSw=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
