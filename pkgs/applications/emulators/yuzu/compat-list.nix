{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-01-30";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "82194fa23ec35545ade47cc3dc2035b2b07badcb";
    hash = "sha256-LsQZml8I43fZDFACtVZpc76/62Pv11Z6bm8w/9hTHdI=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
