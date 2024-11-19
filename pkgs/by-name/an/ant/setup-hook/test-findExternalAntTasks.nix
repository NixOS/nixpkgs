{
  stdenvNoCC,
  writeTextFile,
  ant,
}:
# Check that findExternalAntTasks finds an external Ant task.
let
  fake-ant-task = writeTextFile {
    name = "fake-ant-task";
    text = ''
      Hello world! I am a text file with a misleading file extension.
    '';
    destination = "/share/ant/lib/fake-ant-task.jar";
  };
in
stdenvNoCC.mkDerivation {
  name = "ant-test-setup-hook-findExternalAntTasks";

  src = null;
  dontUnpack = true;

  nativeBuildInputs = [
    # Ant itself isn't needed for this test; we assume antFlags/antFlagsArray works
    ant.hook
    fake-ant-task
  ];

  buildPhase = ''
    echo "$antFlags ''${antFlagsArray[@]}" | grep -F -- '-lib ${fake-ant-task}/share/ant/lib' > "$out"
  '';
}
