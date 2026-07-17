{
  testers,
  dart_frog_cli,
  dart,
}:

let
  testPkgName = "my_frog_project";
in
{
  # Simple help check (Sanity test)
  usage = testers.runCommand {
    name = "dart-frog-usage-test";
    buildInputs = [ dart_frog_cli ];
    script = ''
      export HOME=$TMPDIR
      dart_frog --help > output.txt
      if grep -q "Usage: dart_frog" output.txt; then
        echo "Usage check passed ✅"
        touch $out
      else
        echo "Usage check failed ❌"
        exit 1
      fi
    '';
  };

  # Project creation test (Behavioral test)
  create-project = testers.runCommand {
    name = "dart-frog-create-test";
    buildInputs = [
      dart_frog_cli
      dart
    ];

    script = ''
      export HOME=$TMPDIR

      echo "🔨 Creating new Dart Frog project..."
      dart_frog create ${testPkgName}

      echo "---------------------------------------"
      if [ -d "${testPkgName}" ] && [ -f "${testPkgName}/pubspec.yaml" ]; then
        printf "%-20s %-15s %s\n" "Project Created:" "${testPkgName}" "✅"
        printf "%-20s %-15s %s\n" "Pubspec Found:"   "yes"            "✅"

        # Check if it generated the default route
        if [ -f "${testPkgName}/routes/index.dart" ]; then
           printf "%-20s %-15s %s\n" "Default Route:" "found"         "✅"
        fi

        echo "---------------------------------------"
        echo "Integration test passed successfully! 🚀"
        touch $out
      else
        echo "Project generation failed! ❌"
        exit 1
      fi
    '';
  };
}
