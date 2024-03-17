{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  ...
}:

stdenv.mkDerivation rec {
  pname = "ocis-bin";
  version = "5.0.0";
  system =
    if stdenv.isLinux && stdenv.isx86_64 then
      "linux-amd64"
    else if stdenv.isLinux && stdenv.isAarch64 then
      "linux-arm64"
    else
      "";

  src = fetchurl {
    url = "https://github.com/owncloud/ocis/releases/download/v${version}/ocis-${version}-${system}";

    sha256 =
      if stdenv.isLinux && stdenv.isAarch64 then
        "c51803370991a2f5dbc86439b13530e6caec5cc04363204532907d3285e8a3ec"
      else if stdenv.isLinux && stdenv.isx86_64 then
        "d2580320795d5baecec229df60f0135e45946559d1dcfa170b85cb3352a42a66"
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
    changelog = "https://github.com/owncloud/ocis/releases/tag/v${version}";
    # oCIS is licensed under non-free EULA which can be found here :
    # https://github.com/owncloud/ocis/releases/download/v5.0.0/End-User-License-Agreement-for-ownCloud-Infinite-Scale.pdf
    license = licenses.unfree;
    maintainers = with maintainers; [
      payas
      danth
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
