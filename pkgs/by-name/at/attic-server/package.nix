{ attic-client
}:
(attic-client.override {
  crates = [ "attic-server" ];
}).overrideAttrs {
  meta.mainProgram = "atticd";
}
