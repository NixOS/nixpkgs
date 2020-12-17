{ stdenv, fetchFromGitHub, idris2, nodejs }:
stdenv.mkDerivation {
  name = "kak-idris";
  version = "2020-12-29";

  src = fetchFromGitHub {
    owner = "stoand";
    repo = "kakoune-idris";
    rev = "1acdfb5d89e3951ae4bdf4a5fa2377b36448083d";
    sha256 = "06qny8790j9d7vjs0pfyw71xvc6hmkjl8ssi483mbwbxs0zv6j9r";
  };

  patchPhase = ''
    sed -i 's \bnode\b ${nodejs}/bin/node g' idris.kak
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r . $out/share/kak/autoload/plugins/idris
  '';

  meta = with stdenv.lib;
  { description = "Idris Highlighting and IDE Actions for Kakoune";
    homepage = "https://github.com/stoand/kakoune-idris";
    maintainers = with maintainers; [ malvo ];
    platform = platforms.all;
  };
}
