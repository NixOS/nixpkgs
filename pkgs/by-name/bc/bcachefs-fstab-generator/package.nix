{
  rustPlatform,
  pkg-config,
  systemd,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "bcachefs-fstab-generator";
  version = "0.1.0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "ElvishJerricco";
    repo = "bcachefs-fstab-generator";
    rev = "3efa5d512340f87c3b0453a3cc509c132e960563";
    hash = "sha256-RYclXrauS/ny47XmW2FspWfKSFs9aKJ8OX3dJo7deVg=";
  };

  cargoHash = "sha256-BUMQfRRn90Hn9Cs/FKCb5G8viVuqdrQnvZdbdUauEn8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];
}
