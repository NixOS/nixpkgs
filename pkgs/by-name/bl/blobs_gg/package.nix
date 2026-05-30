{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

let
  rev = "e764ba00b9c34524e3ff3ffd19a44fa2a5c296a5";
in
stdenvNoCC.mkDerivation {
  pname = "blobs.gg";
  version = "unstable-2019-07-24";

  src = fetchurl {
    url = "https://git.pleroma.social/pleroma/emoji-index/-/raw/${rev}/packs/blobs_gg.zip";
    hash = "sha256-OhLzoYFnjVs1hKYglUEbDWCjNRGBNZENh5kg+K3lpX8=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Blob emoji from blobs.gg repacked as APNG";
    homepage = "https://blobs.gg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mvs ];
  };
}
