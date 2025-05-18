{
  stdenv,
  lib,
  fetchFromGitHub,
  swift,
  swiftformat,
  swiftpm,
  testers,
  versionCheckHook,
  nix-update-script,
}:

swift.stdenv.mkDerivation rec {
  pname = "swiftformat";
  version = "0.55.6";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    rev = version;
    sha256 = "sha256-zp7wx2PL0WSgjfWu5GSLfYb8BaTmCoF+Or6prZ4TSC4=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    install -D "$(swiftpmBinPath)/swiftformat" $out/bin/swiftformat
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
}
