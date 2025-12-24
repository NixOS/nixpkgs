{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  blobtools,
  dhtbsign,
  elftool,
  futility,
  loki-tool,
  lz4,
  mboot,
  mkbootimg-osm0sis,
  mkmtkhdr,
  pxa-mkbootimg,
  rkflashtool,
  sony-dump,
  ubootTools,
  unpackelf,
}:
stdenv.mkDerivation {
  pname = "android-image-kitchen";
  version = "0-unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "SebaUbuntu";
    repo = "AIK-Linux-mirror";
    rev = "1c1411bd685bbc5fb4112484af2ad07cb6807f30";
    hash = "sha256-auwAXWzUAFS8USTTH9h5nPzmoGOZf53GkLA+KNGl8uc=";
  };

  patches = [
    ./0001-Use-PATH-to-find-programs.patch
    ./0002-Do-not-change-directory.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace {cleanup,repackimg,unpackimg}.sh \
      --replace-fail "bin=\"\$aik/bin\";" "bin=$out/share"
  '';

  installPhase = ''
    runHook preInstall

    for i in cleanup repackimg unpackimg; do
      install -Dm 555 "$i.sh" "$out/bin/aik-$i"
    done

    # Remove prebuilt binaries
    rm -rf bin/{linux,macos}

    # Copy rest of the required files
    mkdir -p $out/share
    cp -rT bin $out/share

    runHook postInstall
  '';

  postInstall = ''
    for i in $out/bin/aik-{cleanup,repackimg,unpackimg}; do
      wrapProgram $i --prefix PATH : ${
        lib.makeBinPath [
          blobtools
          dhtbsign
          elftool
          futility
          loki-tool
          lz4
          mboot
          mkbootimg-osm0sis
          mkmtkhdr
          pxa-mkbootimg
          rkflashtool
          sony-dump
          ubootTools
          unpackelf
        ]
      }
    done
  '';

  meta = {
    description = "Unpack & repack Android boot files";
    homepage = "https://github.com/SebaUbuntu/AIK-Linux-mirror";
    # No license specified in the repository
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "aik-unpackimg";
  };
}
