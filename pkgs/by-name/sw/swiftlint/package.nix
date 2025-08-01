{
  stdenvNoCC,
  stdenv,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
  autoPatchelfHook,
  curl,
  libxml2,
  versionCheckHook,
}:
let
  system = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation rec {
  pname = "swiftlint";
  version = "0.59.1";

  src = fetchurl {
    url =
      let
        filename =
          {
            x86_64-darwin = "portable_swiftlint.zip";
            aarch64-darwin = "portable_swiftlint.zip";
            x86_64-linux = "swiftlint_linux.zip";
          }
          .${system};
      in
      "https://github.com/realm/SwiftLint/releases/download/${version}/${filename}";

    hash =
      {
        x86_64-darwin = "sha256-WPm+ikZ3kAyUXixhgWgiP03WIKDMZcnMxeoPcEM+icE=";
        aarch64-darwin = "sha256-WPm+ikZ3kAyUXixhgWgiP03WIKDMZcnMxeoPcEM+icE=";
        x86_64-linux = "sha256-05zlMGHw/YAMVHQfXnh4OZ99LXP4QfP5POLZE1K+4Ps=";
      }
      .${system};
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    curl
    libxml2
    stdenv.cc.cc.lib
  ];

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    # Copy libxml2 library for compatibility with binary's expected .so.2 name
    mkdir -p $out/lib
    cp ${libxml2.out}/lib/libxml2.so.16.0.4 $out/lib/libxml2.so.2
  '';

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 swiftlint $out/bin/swiftlint
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to enforce Swift style and conventions";
    homepage = "https://realm.github.io/SwiftLint/";
    license = lib.licenses.mit;
    mainProgram = "swiftlint";
    maintainers = with lib.maintainers; [
      matteopacini
      DimitarNestorov
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
