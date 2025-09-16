{
  lib,
  fetchFromGitHub,
  buildDartApplication,
  buf,
  protoc-gen-dart,
  writableTmpDirAsHomeHook,
  testers,
  dart-sass,
  runCommand,
  writeText,
}:

let
  embedded-protocol-version = "3.2.0";

  embedded-protocol = fetchFromGitHub {
    owner = "sass";
    repo = "sass";
    tag = "embedded-protocol-${embedded-protocol-version}";
    hash = "sha256-yX30i1gbVZalVhefj9c37mpFOIDaQlsLeAh7UnY56ro=";
  };
in
buildDartApplication rec {
  pname = "dart-sass";
  version = "1.92.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "dart-sass";
    tag = version;
    hash = "sha256-ee1ED6CeRQnv+jopgupelWybiH3h05Lk1TUgYUS8rNo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    buf
    protoc-gen-dart
    writableTmpDirAsHomeHook
  ];

  preConfigure = ''
    mkdir -p build
    ln -s ${embedded-protocol} build/language
    buf generate
  '';

  dartCompileFlags = [ "--define=version=${version}" ];

  postInstall = ''
    # dedupe identiall binaries
    ln -rsf $out/bin/{,dart-}sass
  '';

  passthru = {
    inherit embedded-protocol-version embedded-protocol;
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion {
        package = dart-sass;
        command = "dart-sass --version";
      };

      simple = testers.testEqualContents {
        assertion = "dart-sass compiles a basic scss file";
        expected = writeText "expected" ''
          body h1{color:#123}
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ dart-sass ];
              base = writeText "base" ''
                body {
                  $color: #123;
                  h1 {
                    color: $color;
                  }
                }
              '';
            }
            ''
              dart-sass --style=compressed $base > $out
            '';
      };
    };
  };

  meta = {
    homepage = "https://github.com/sass/dart-sass";
    description = "Reference implementation of Sass, written in Dart";
    mainProgram = "sass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
