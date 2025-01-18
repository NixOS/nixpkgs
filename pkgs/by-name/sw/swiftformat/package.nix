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
  version = "0.55.4";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    rev = version;
    sha256 = "sha256-0Dk2SgfPozgbdhyQa74NZkd/kA6JleSfpHDn4NuQdEo=";
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

  meta = with lib; {
    description = "Code formatting and linting tool for Swift";
    homepage = "https://github.com/nicklockwood/SwiftFormat";
    license = licenses.mit;
    maintainers = with maintainers; [
      bdesham
      DimitarNestorov
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
