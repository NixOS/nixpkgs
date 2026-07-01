{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  callPackage,
}:

{
  pname,
  owner,
  repo,
  sourcesJson,
  tagPrefix ? "v",
  ...
}@args:

let
  sources = lib.importJSON sourcesJson;
  inherit (sources) version assets;

  asset =
    assets.${stdenv.hostPlatform.system}
      or (throw "buildGithubBinary: unsupported platform ${stdenv.hostPlatform.system} for ${pname}");

  src = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${tagPrefix}${version}/${asset.asset}";
    inherit (asset) sha256;
  };

  isTarball = lib.any (ext: lib.hasSuffix ext asset.asset) [
    ".tar.gz"
    ".tgz"
    ".tar.xz"
    ".tar.bz2"
    ".tar.zst"
  ];
  isGzippedBinary = lib.hasSuffix ".gz" asset.asset && !lib.hasSuffix ".tar.gz" asset.asset;

  mainProgram = args.meta.mainProgram or pname;

  unpackPhase =
    if isTarball then
      ''
        runHook preUnpack
        tar -xf $src --strip-components=1
        runHook postUnpack
      ''
    else if isGzippedBinary then
      ''
        runHook preUnpack
        gzip -d < $src > ${mainProgram}
        chmod +x ${mainProgram}
        runHook postUnpack
      ''
    else
      ''
        runHook preUnpack
        cp $src ${mainProgram}
        chmod +x ${mainProgram}
        runHook postUnpack
      '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ${mainProgram} $out/bin/${mainProgram}
    runHook postInstall
  '';

  nixpkgsRoot = toString ../../..;
  sourcesJsonAbsolute = toString sourcesJson;
  sourcesJsonRelative =
    if lib.hasPrefix (nixpkgsRoot + "/") sourcesJsonAbsolute then
      lib.removePrefix (nixpkgsRoot + "/") sourcesJsonAbsolute
    else
      throw "buildGithubBinary: sourcesJson (${sourcesJsonAbsolute}) must live inside the nixpkgs tree (${nixpkgsRoot})";

  updateScript = callPackage ./update.nix { } {
    inherit
      pname
      owner
      repo
      tagPrefix
      ;
    sourcesJson = sourcesJsonRelative;
    platforms = builtins.attrNames assets;
  };

  forwardedArgs = removeAttrs args [
    "owner"
    "repo"
    "tagPrefix"
    "sourcesJson"
  ];

  passthru = (args.passthru or { }) // {
    inherit updateScript;
  };

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames assets;
  }
  // (args.meta or { });
in
stdenv.mkDerivation (
  forwardedArgs
  // {
    inherit
      pname
      version
      src
      unpackPhase
      installPhase
      passthru
      meta
      ;

    strictDeps = args.strictDeps or true;
    __structuredAttrs = args.__structuredAttrs or true;

    nativeBuildInputs =
      (args.nativeBuildInputs or [ ]) ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

    buildInputs =
      (args.buildInputs or [ ]) ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc ];

    dontStrip = args.dontStrip or true;
  }
)
