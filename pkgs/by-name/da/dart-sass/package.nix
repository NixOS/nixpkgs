{
  lib,
  fetchFromGitHub,
  buildDartApplication,
  buf,
  protoc-gen-dart,
  testers,
  dart-sass,
  runCommand,
  writeText,
}:

let
  embedded-protocol-version = "3.1.0";

  embedded-protocol = fetchFromGitHub {
    owner = "sass";
    repo = "sass";
    rev = "refs/tags/embedded-protocol-${embedded-protocol-version}";
    hash = "sha256-DBoGACNhc9JMT8D+dO50aKUitY8xx/3IGj/XntFts1w=";
  };
in
buildDartApplication rec {
  pname = "dart-sass";
  version = "1.83.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-BT9ubYNireRXWqTHRrL7gHXle6tX3pjKG3siQ9TNf1M=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    buf
    protoc-gen-dart
  ];

  preConfigure = ''
    mkdir -p build
    ln -s ${embedded-protocol} build/language
    HOME="$TMPDIR" buf generate
  '';

  dartCompileFlags = [ "--define=version=${version}" ];

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
