{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jq,
  curl,
  testers,
}:

let
  versions = lib.importJSON ./versions.json;
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "Unsupported architecture";

  os =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "macos"
    else
      throw "Unsupported OS";
  inherit (versions.passCliVersions.urls.${os}.${arch}) url hash;
  inherit (versions.passCliVersions) version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proton-pass-cli";
  inherit version;

  # run ./update
  src = fetchurl {
    inherit url;
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/pass-cli
    chmod +x $out/bin/pass-cli

    # add dependencies
    wrapProgram $out/bin/pass-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          curl
        ]
      }
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pass-cli --version";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Command-line interface for Proton Pass";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.kirksw ];
    mainProgram = "pass-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
