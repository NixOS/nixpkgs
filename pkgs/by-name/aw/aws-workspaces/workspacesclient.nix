{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeBinaryWrapper,
  glib-networking,
  wrapGAppsHook4,
  glib,
}:

let
  dcv-path = "lib/x86_64-linux-gnu/workspacesclient";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "workspacesclient";
  version = "2025.1.5526-1";

  src = fetchurl {
    urls = [
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/noble/main/binary-amd64/workspacesclient_${finalAttrs.version}_amd64.ubuntu2404.deb"
    ];
    hash = "sha256-iGYKpbpzGNeEUKgozhSwVd9dWRgQEbozIAWRu7wu2D8=";
  };

  nativeBuildInputs = [
    dpkg
    makeBinaryWrapper
    wrapGAppsHook4
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R usr/* $out/

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"

    runHook postInstall
  '';

  preFixup = ''
    schemadir=${glib.makeSchemaPath "$out" "$name"}
    mv $out/share/workspacesclient/schemas/* $schemadir
    glib-compile-schemas $schemadir
  '';

  postFixup = ''
    # provide network support
    wrapProgram "$out/bin/workspacesclient" \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \

    # dcvclient does not setup the environment correctly.
    # Instead wrap the binary directly the correct environment paths
    mv $out/${dcv-path}/dcvviewer $out/${dcv-path}/workspacesclientdcv
    wrapProgram $out/${dcv-path}/workspacesclientdcv \
      --suffix LD_LIBRARY_PATH : $out/${dcv-path} \
      --suffix GIO_EXTRA_MODULES : ${dcv-path}/gio/modules \
      --set DCV_SASL_PLUGIN_DIR $out/${dcv-path}/sasl2 \

    # shrink the install by removing all vendored libraries which will be provided by Nixpkgs
    find $out/${dcv-path} -name lib\* ! -name libdcv\* ! -name libgioopenssl\* | xargs rm
  '';

  meta = {
    description = "Client for Amazon WorkSpaces, a managed, secure Desktop-as-a-Service (DaaS) solution";
    homepage = "https://clients.amazonworkspaces.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "workspacesclient";
    maintainers = with lib.maintainers; [
      mausch
      dylanmtaylor
    ];
    platforms = [ "x86_64-linux" ]; # TODO Mac support
  };
})
