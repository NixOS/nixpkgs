{
  testers,
  pana,
  git,
  jq,
}:
let
  testPkgName = "dummy_pkg";

  testLicense = ''
    MIT License

    Copyright (c) 2026 The Nixpkgs Authors

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  '';
in
{
  usage = testers.runCommand {
    name = "pana-usage-test";
    buildInputs = [ pana ];
    script = ''
      export HOME=$TMPDIR
      pana > output.txt 2>&1 || true
      if grep -q "Usage: pana" output.txt; then
        touch $out
      else
        echo "Usage string not found in output."
        exit 1
      fi
    '';
  };

  # Comprehensive behavioral test
  json-output = testers.runCommand {
    name = "pana-json-test";
    buildInputs = [
      pana
      git
      jq
    ];

    script = ''
            # Nix sandbox environment setup
            export HOME=$TMPDIR
            export PUB_HOSTED_URL="http://localhost:0"

            init_package() {
              # Initialize a valid Dart package structure
              mkdir -p my_package/lib my_package/example
              cd my_package

              git init -b main
              git config user.email "test@example.com"
              git config user.name "Nix-Tester"

              cat > pubspec.yaml <<EOF
      name: ${testPkgName}
      version: 1.0.0
      description: >-
        A comprehensive test package for Nixpkgs validation that meets
        all the professional documentation requirements for pana scoring.
      repository: https://github.com/nixos/nixpkgs
      environment:
        sdk: '>=3.0.0 <4.0.0'
      EOF

              cat > lib/${testPkgName}.dart <<EOF
      /// A simple function to say hello.
      void hello() => print('hi');
      EOF

              cat > example/main.dart <<EOF
      import 'package:${testPkgName}/${testPkgName}.dart';
      void main() => hello();
      EOF

              echo "# Dummy Pkg" > README.md
              echo "## 1.0.0" > CHANGELOG.md
              cat > LICENSE <<EOF
      ${testLicense}
      EOF

              git add . && git commit -m "feat: initial package"
            }

            determine_marks() {
              PKG_NAME=$(jq -r '.packageName' report.json)
              # Extract the first license identifier found
              LICENSE_ID=$(jq -r '.result.licenses[0].spdxIdentifier' report.json)
              # Extract the status of the documentation section
              DOC_STATUS=$(jq -r '.report.sections[] | select(.id == "documentation") | .status' report.json)

              PASS="✅"
              FAIL="❌"

              # Determine marks
              [[ "$PKG_NAME" == "${testPkgName}" ]] && MARK_NAME="$PASS" || MARK_NAME="$FAIL"
              [[ "$LICENSE_ID" == "MIT" ]]     && MARK_LIC="$PASS"  || MARK_LIC="$FAIL"
              [[ "$DOC_STATUS" == "passed" ]]  && MARK_DOC="$PASS"  || MARK_DOC="$FAIL"

              echo "---------------------------------------"
              printf "%-10s %-20s %s\n" "Package:" "$PKG_NAME"   "$MARK_NAME"
              printf "%-10s %-20s %s\n" "License:" "$LICENSE_ID" "$MARK_LIC"
              printf "%-10s %-20s %s\n" "Docs:"    "$DOC_STATUS" "$MARK_DOC"
              echo "---------------------------------------"
            }

            check_marks() {
              if [[ "$MARK_NAME" == "$PASS" && "$MARK_LIC" == "$PASS" && "$MARK_DOC" == "$PASS" ]]; then
                echo "Integration test passed successfully! 🚀"
                touch $out
              else
                echo "Integration test failed metadata verification! ⚠️"
                # Print specifically why it failed to the log
                jq -r '.report.sections[] | select(.status == "failed") | "Section [\(.id)]: \(.summary)"' report.json
                exit 1
              fi
            }

            main() {
              init_package
              echo "Running pana analysis...🔍"
              pana --json . > report.json
              determine_marks
              check_marks
            }

            main
    '';
  };
}
