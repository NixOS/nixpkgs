{
  lib,
  fetchurl,
  stdenvNoCC,
  # `basic` flavor is largely enough for the test system.
  # `cloudimg` exist too.
  variant ? "basic",
  # Arch uses rolling-release snapshot timestamps rather than version numbers.
  release ? "20261101.620452",
  arch ? stdenvNoCC.hostPlatform.qemuArch,
  archHashes ? {
    x86_64 = "sha256-vFLk3HnNVbVa4tHBGbH/5h6T9VReqADVGDoEZo3h6WI=";
  },
}:

let
  dirName = "v${release}";
  fileName = "Arch-Linux-${arch}-${variant}-${release}.qcow2";

  src = fetchurl {
    name = fileName;
    url = "https://geo.mirror.pkgbuild.com/images/${dirName}/${fileName}";
    hash =
      archHashes.${arch}
        or (throw "arch-cloud-image: no hash pinned for ${arch}, add it to `archHashes`");
  };
in
stdenvNoCC.mkDerivation {
  name = "arch-${variant}-${arch}.qcow2";

  inherit src;

  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    ln -s "$src" "$out"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Arch Linux ${variant} cloud image for ${arch}";
    longDescription = ''
      A stock Arch Linux cloud image, unmodified.

      This is used for the non-NixOS VM runner as it
      fulfills all the conditions w.r.t. systemd.
    '';
    homepage = "https://gitlab.archlinux.org/archlinux/arch-boxes";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.raitobezarius ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    # Never build this on Hydra.
    hydraPlatforms = [ ];
  };
}
