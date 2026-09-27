{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.rosbags).overrideAttrs (_: {
  meta.mainProgram = "rosbags-convert";
})
