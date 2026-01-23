{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeBinaryWrapper,
  glib-networking,
}:

let
  dcv-path = "lib/x86_64-linux-gnu/workspacesclient/dcv";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "workspacesclient";
  version = "2025.0.5296";

  src = fetchurl {
    urls = [
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/main/binary-amd64/workspacesclient_${finalAttrs.version}_amd64.deb"
    ];
    hash = "sha256-VPNZN9AsrGJ56O8B5jxlgLMvrUViTv6yto8c5pGQc0A=";
  };

  nativeBuildInputs = [
    dpkg
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R usr/* $out/

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"

    runHook postInstall
  '';

  postFixup = ''
    # provide network support
    wrapProgram "$out/bin/workspacesclient" \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \

    # dcvclient does not setup the environment correctly.
    # Instead wrap the binary directly the correct environment paths
    mv $out/${dcv-path}/dcvclientbin $out/${dcv-path}/dcvclient
    wrapProgram $out/${dcv-path}/dcvclient \
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
