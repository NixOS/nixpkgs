let
  inherit (import <nixpkgs> { }) snapTools hello;
in snapTools.makeSnap {
  meta = {
    name = "hello";
    summary = hello.meta.description;
    description = hello.meta.longDescription;
    architectures = [ "amd64" ];
    confinement = "strict";
    apps.hello.command = "${hello}/bin/hello";
  };
}
