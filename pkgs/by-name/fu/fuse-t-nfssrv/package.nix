{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fuse-t-nfssrv";
  version = "1.2.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/macos-fuse-t/fuse-t/releases/download/${finalAttrs.version}/fuse-t-macos-installer-${finalAttrs.version}.pkg";
    hash = "sha256-obiTdA3tjqA08azFIt7RFE9KVnofQW2u+MFEHPJmL38=";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack
    xar -xf $src fuse-t-core.pkg/Payload fuse-t-fskit.pkg/Payload
    gunzip -dc fuse-t-core.pkg/Payload | cpio -i --quiet
    gunzip -dc fuse-t-fskit.pkg/Payload | cpio -i --quiet
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    fuseDir="Library/Application Support/fuse-t"
    install -Dm755 "$fuseDir/bin/go-nfsv4-${finalAttrs.version}" $out/bin/go-nfsv4
    install -Dm644 "$fuseDir/cfg/fuse-t.ini" $out/share/fuse-t/fuse-t.ini
    install -Dm644 "$fuseDir/LICENSE.rtf" $out/share/licenses/fuse-t/LICENSE.rtf

    # FSKit module used by the server's `fskit` backend on macOS 26 and later.
    mkdir -p $out/Applications
    cp -R Applications/fuse-t.app $out/Applications/

    runHook postInstall
  '';

  # The binary is signed by upstream; stripping or patching would break that.
  dontFixup = true;

  meta = {
    description = "NFS server used by FUSE-T to serve FUSE filesystems on macOS";
    longDescription = ''
      The `go-nfsv4` server that FUSE-T's libfuse spawns for each mount. Point
      `FUSE_NFSSRV_PATH` at `bin/go-nfsv4` from this package, or build
      `libfuse-t` with `withNfssrv = true` to bake the path in.

      On macOS 26 and later, mounting with `-o backend=fskit` uses FSKit
      instead of NFS. This needs `Applications/fuse-t.app` from this package
      installed under `/Applications` and its extension enabled in System
      Settings → General → Login Items & Extensions → File System Extensions.
    '';
    homepage = "https://www.fuse-t.org/";
    changelog = "https://github.com/macos-fuse-t/fuse-t/releases/tag/${finalAttrs.version}";
    # Free for non-commercial use only.
    # https://github.com/macos-fuse-t/fuse-t/blob/main/License.txt
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "go-nfsv4";
    maintainers = with lib.maintainers; [ bryanhonof ];
    platforms = lib.platforms.darwin;
  };
})
