{
  lib,
  fetchFromGitHub,
  runCommand,
  swift,
  swiftpm,
  versionCheckHook,
  nix-update-script,
}:

swift.stdenv.mkDerivation (finalAttrs: {
  pname = "swiftformat";
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    rev = finalAttrs.version;
    sha256 = "sha256-h0d/vdoKZuYJkMO+TmFFgomaSVA94P+MKclSlBlIleE=";
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

    tests.format =
      runCommand "swiftformat-test-format"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          export CACHE_DIR=$(mktemp -d)
          printf "class Test{\nvar a:Int=1;;\n}" > test.swift
          swiftformat --cache $CACHE_DIR --swiftversion 5.8 --indent 2 test.swift 2> stderr.txt

          grep -Fxq "Running SwiftFormat..." stderr.txt
          grep -Fxq "1/1 files formatted." stderr.txt

          cat > expected.swift <<'EOF'
          class Test {
            var a: Int = 1
          }
          EOF

          cmp expected.swift test.swift

          swiftformat --cache $CACHE_DIR --swiftversion 5.8 --indent 2 test.swift 2> stderr.txt

          grep -Fxq "Running SwiftFormat..." stderr.txt
          grep -Fxq "0/1 files formatted." stderr.txt

          cmp expected.swift test.swift

          touch $out
        '';
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
