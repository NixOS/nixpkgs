{
  stdenv,
  lib,
  fetchFromGitHub,
  swift,
  swiftpm,
  versionCheckHook,
  nix-update-script,
}:

swift.stdenv.mkDerivation (finalAttrs: {
  pname = "swiftformat";
  version = "0.58.5";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    tag = finalAttrs.version;
    hash = "sha256-QTfdMJpdm4m2YSZefPclGcAZFjyFgJeeWIYLf3apuFo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    swiftpm
  ];

  installPhase = ''
    runHook preInstall

    install -D "$(swiftpmBinPath)/swiftformat" $out/bin/swiftformat

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Code formatting and linting tool for Swift";
    homepage = "https://github.com/nicklockwood/SwiftFormat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bdesham
      DimitarNestorov
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
