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
  version = "0.4.0";
  vendorHash = "sha256-u2f9aHUrfuM4ZsTWA955sCkgcGBFlNhEU2Qlq2C2Kso=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${version}";
    hash = "sha256-gfZFLlTFofYQ72rQjgB8g012vbxFjk8bLYTVJwZNgMs=";
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
