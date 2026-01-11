{
  python3Packages,
  writeShellApplication,
  withSwhPythonPackages ? [
    python3Packages.swh-auth
    python3Packages.swh-export
    python3Packages.swh-model
    python3Packages.swh-objstorage
    python3Packages.swh-scanner
    python3Packages.swh-scheduler
    python3Packages.swh-storage
    python3Packages.swh-web-client
  ],
}:

let
  python3' = python3Packages.python.withPackages (ps: with ps; [ swh-core ] ++ withSwhPythonPackages);
in
writeShellApplication {
  name = "swh";
  text = ''
    ${python3'}/bin/swh "$@"
  '';
  meta = {
    inherit (python3Packages.swh-core.meta) license mainProgram platforms;
    description = "Software Heritage command-line client";
  };
}
