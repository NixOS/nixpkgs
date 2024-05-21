{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocis-bin";
  version = "5.0.1";
  system =
    if stdenv.isLinux && stdenv.isx86_64 then
      "linux-amd64"
    else if stdenv.isLinux && stdenv.isAarch64 then
      "linux-arm64"
    else
      "";

  src = fetchurl {
    url = "https://github.com/owncloud/ocis/releases/download/v${finalAttrs.version}/ocis-${finalAttrs.version}-${finalAttrs.system}";

    hash =
      if stdenv.isLinux && stdenv.isAarch64 then
        "sha256-8AEXuwTodhqF0LF1duYItntgp9mxoIdHChbtAnnnaQg="
      else if stdenv.isLinux && stdenv.isx86_64 then
        "sha256-Fz0ee0Lu0CL3xJbsp1CCl0rsN/p48BdOj8oVOf0QSh4="
      else
        builtins.throw "Unsupported platform, please contact Nixpkgs maintainers for ocis package";
  };
  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/bin/ocis
    runHook postInstall
  '';

  meta = with lib; {
    description = "ownCloud Infinite Scale Stack ";
    homepage = "https://owncloud.dev/ocis/";
    changelog = "https://github.com/owncloud/ocis/releases/tag/v${finalAttrs.version}";
    # oCIS is licensed under non-free EULA which can be found here :
    # https://github.com/owncloud/ocis/releases/download/v5.0.1/End-User-License-Agreement-for-ownCloud-Infinite-Scale.pdf
    license = licenses.unfree;
    maintainers = with maintainers; [
      ramblurr
      bhankas
      danth
      ramblurr
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "ocis";
  };
})
