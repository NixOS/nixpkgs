{
  lib,
  stdenv,
  fetchFromGitHub,
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

  postPatch = ''
    # We already take care of chmod in installPhase
    SUBST='chmod 644 "$bin/magic" "$bin/androidbootimg.magic" "$bin/androidsign.magic" "$bin/boot_signer.jar" "$bin/avb/"* "$bin/chromeos/"*;'
    substituteInPlace {cleanup,repackimg,unpackimg}.sh \
      --replace-fail \
        'chmod -R 755 "$bin" "$aik"/*.sh;' "" \
      --replace-fail "$SUBST" ""
  '';

  installPhase =
    let
      platform =
        if stdenv.hostPlatform.isDarwin then
          "macos"
        else if stdenv.hostPlatform.isLinux then
          "linux"
        else
          throw "Unsupported platform: ${stdenv.hostPlatform.system}";
      processor = stdenv.hostPlatform.uname.processor;
    in
    ''
      runHook preInstall

      install -Dm 555 {cleanup,repackimg,unpackimg}.sh -t $out

      # Replace prebuilt binaries
      rm -rf bin/{linux,macos}

      cp -r bin $out
      mkdir -p $out/bin/${platform}/${processor}

      chmod -R u+rwX,go+rX $out

      # Symlink every required program
      # since AIK does not look into $PATH
      ln -s ${
        lib.concatStringsSep " " [
          "${blobtools}/bin/*"
          "${mkbootimg-osm0sis}/bin/*"
          "${pxa-mkbootimg}/bin/pxa-{mk,unpack}bootimg"
          "${ubootTools}/bin/{dumpimage,mkimage}"
          (lib.getExe dhtbsign)
          (lib.getExe elftool)
          (lib.getExe futility)
          (lib.getExe loki-tool)
          (lib.getExe lz4)
          (lib.getExe mboot)
          (lib.getExe mkmtkhdr)
          (lib.getExe' rkflashtool "rkcrc")
          (lib.getExe sony-dump)
          (lib.getExe unpackelf)
        ]
      } $out/bin/${platform}/${processor}

      runHook postInstall
    '';

  meta = {
    description = "Unpack & repack Android boot files";
    homepage = "https://github.com/SebaUbuntu/AIK-Linux-mirror";
    # No license specified in the repository
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
