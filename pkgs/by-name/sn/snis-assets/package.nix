{
  lib,
  stdenv,
  fetchurl,
}:

let
  # Original manifest file at https://spacenerdsinspace.com/snis-assets/manifest.txt transformed using
  # awk '{print $2}' manifest.txt | grep -v -E '\.stl$' | xargs cksum -a sha256 --base64 --untagged
  manifest = ./manifest.txt;
  assets = lib.lists.init (lib.strings.splitString "\n" (builtins.readFile manifest));
  ASSET_URL = "https://spacenerdsinspace.com/snis-assets";
in
stdenv.mkDerivation {
  pname = "snis_assets";
  version = "2024-08-02";

  srcs = map (
    line:
    let
      asset = lib.strings.splitString "  " line;
    in
    fetchurl {
      url = "${ASSET_URL}/${builtins.elemAt asset 1}";
      hash = "sha256-${builtins.elemAt asset 0}";
    }
  ) assets;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    read -r -a store_paths <<< "$srcs"
    mapfile -t out_paths < <(awk '{print $2}' ${manifest})

    for i in ''${!store_paths[@]}
    do
      install -m 444 -D ''${store_paths[$i]} $out/''${out_paths[$i]}
    done
  '';

  meta = with lib; {
    description = "Assets for Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    license = [
      licenses.cc-by-sa-30
      licenses.cc-by-30
      licenses.cc0
      licenses.publicDomain
    ];
    maintainers = with maintainers; [ alyaeanyx ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
  };
}
