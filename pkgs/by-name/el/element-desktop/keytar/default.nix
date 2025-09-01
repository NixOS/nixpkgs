{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  python3,
  removeReferencesTo,
  pkg-config,
  libsecret,
  xcbuild,
  fetchNpmDeps,
  npmHooks,
  electron,
}:

let
  pinData = lib.importJSON ./pin.json;
in
stdenv.mkDerivation rec {
  pname = "keytar-forked";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "shiftkey";
    repo = "node-keytar";
    rev = "v${version}";
    hash = pinData.srcHash;
  };

  nativeBuildInputs = [
    nodejs
    python3
    pkg-config
    npmHooks.npmConfigHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin xcbuild;

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ];

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = pinData.npmHash;
  };

  doCheck = false;

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    pkg-config() { "''${PKG_CONFIG}" "$@"; }
    export -f pkg-config
  '';

  npmFlags = [
    # Make sure the native modules are built against electron's ABI
    "--nodedir=${electron.headers}"
    # https://nodejs.org/api/os.html#osarch
    "--arch=${stdenv.hostPlatform.node.arch}"
  ];

  installPhase = ''
    runHook preInstall
    shopt -s extglob
    rm -rf node_modules
    mkdir -p $out
    cp -r ./!(build) $out
    install -D -t $out/build/Release build/Release/keytar.node
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $out/build/Release/keytar.node
    runHook postInstall
  '';

  disallowedReferences = [ stdenv.cc.cc ];
}
