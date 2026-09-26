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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "remko";
    repo = "age-plugin-se";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ga9EYfvscXf8VHSptjgnjaeZT+D/69PAr/s53JOHG20=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    # Can't find libdispatch without this on NixOS. (swift 5.8)
    LD_LIBRARY_PATH = "${swiftPackages.Dispatch}/lib";
  };

  postPatch =
    let
      swift-crypto = fetchFromGitHub {
        owner = "apple";
        repo = "swift-crypto";
        tag = "3.7.1";
        hash = "sha256-zxmHxTryAezgqU5qjXlFFThJlfUsPxb1KRBan4DSm9A=";
      };
    in
    ''
      ${lib.optionalString (lib.versionAtLeast swift.version "6") ''
        echo "age-plugin-se still applies patch-package-swift-legacy; remove or revisit this patch now that nixpkgs Swift is 6+."
        exit 1
      ''}
      make patch-package-swift-legacy
      ln -s ${swift-crypto} swift-crypto
      substituteInPlace Package.swift --replace-fail 'url: "https://github.com/apple/swift-crypto.git"' 'path: "./swift-crypto"), //'
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        # Swift 5.10.1's corelibs Foundation lacks Date.ISO8601Format().
        # Remove this substitution once the upstream fallback is released:
        # https://github.com/remko/age-plugin-se/issues/20
        substituteInPlace Sources/Plugin.swift --replace-fail \
          'let createdAt = now.ISO8601Format()' \
          'let createdAt = ISO8601DateFormatter().string(from: now)'
      ''}
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
