{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "agneyastra";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "JA3G3R";
    repo = "agneyastra";
    # https://github.com/JA3G3R/agneyastra/issues/1
    rev = "16a90ecc7189e12261a24b88e6d6ac24b7f3b216";
    hash = "sha256-I3BzHS7D8ZVRLzx8TlUmebw96wTVwSkAAKsDqJ2Ekj8=";
  };

  vendorHash = "sha256-urAw78X6mY2O+rLdQvA6eubFk7XmzEzPQPKc/QudVTQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Firebase Misconfiguration Detection Toolkit";
    homepage = "https://github.com/JA3G3R/agneyastra";
    # https://github.com/JA3G3R/agneyastra/issues/2
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "agneyastra";
  };
}
