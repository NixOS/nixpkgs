{
  lib,
  fetchFromGitHub,
  llvmPackages,
  swiftPackages,
  swift,
  swiftpm,
  nix-update-script,
}:
let
  inherit (llvmPackages) stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "age-plugin-se";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "remko";
    repo = "age-plugin-se";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sg73DzlW4aXNbIIePZox4JkF10OfsMtPw0q/0DWwgDk=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  # Can't find libdispatch without this on NixOS. (swift 5.8)
  LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isLinux "${swiftPackages.Dispatch}/lib";

  postPatch =
    let
      swift-crypto = fetchFromGitHub {
        owner = "apple";
        repo = "swift-crypto";
        # FIXME: Update to a newer version once https://github.com/NixOS/nixpkgs/issues/343210 is fixed
        # This is the last version to support swift tools 5.8 which is newest version supported by nixpkgs:
        # https://github.com/apple/swift-crypto/commit/35703579f63c2518fc929a1ce49805ba6134137c
        tag = "3.7.1";
        hash = "sha256-zxmHxTryAezgqU5qjXlFFThJlfUsPxb1KRBan4DSm9A=";
      };
    in
    ''
      ln -s ${swift-crypto} swift-crypto
      substituteInPlace Package.swift --replace-fail 'url: "https://github.com/apple/swift-crypto.git"' 'path: "./swift-crypto"), //'
    '';

  makeFlags = [
    "PREFIX=$(out)"
    "RELEASE=1"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Age plugin for Apple's Secure Enclave";
    homepage = "https://github.com/remko/age-plugin-se/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onnimonni
      remko
    ];
    mainProgram = "age-plugin-se";
    platforms = lib.platforms.unix;
  };
})
