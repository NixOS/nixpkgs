{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-02-26";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "9c2032a3c7e64772a8112b77ed8b660242172068";
    hash = "sha256-ITh/W4vfC9w9t+TJnPeTZwWifnhTNKX54JSSdpgaoBk=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
