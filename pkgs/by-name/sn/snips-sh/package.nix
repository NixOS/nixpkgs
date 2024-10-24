{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  libtensorflow,
  withTensorflow ? false,
}:
buildGoModule rec {
  pname = "snips-sh";
  version = "0.4.1";
  vendorHash = "sha256-weqlhnhUG2gn9SFS63q1LYmPa7liGYYcJN5qorj6x2E=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${version}";
    hash = "sha256-FEo2/TPwes8/Iwfp7OIo1HbLWF9xmVS9ZMC9HysyK/k=";
  };

  tags = (lib.optional (!withTensorflow) "noguesser");

  buildInputs = [ sqlite ] ++ (lib.optional withTensorflow libtensorflow);

  meta = {
    description = "passwordless, anonymous SSH-powered pastebin with a human-friendly TUI and web UI";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://snips.sh";
    maintainers = with lib.maintainers; [ jeremiahs ];
    mainProgram = "snips.sh";
  };
}
