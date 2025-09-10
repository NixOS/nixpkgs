{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  wl-clipboard,
  xclip,
}:

buildGoModule rec {
  pname = "gtt";
  version = "10";

  src = fetchFromGitHub {
    owner = "eeeXun";
    repo = "gtt";
    rev = "v${version}";
    hash = "sha256-ghdf8UQA+SfsBiD5bPrNZM8sPE+Xhbhn18iNl3xLh8c=";
  };

  vendorHash = "sha256-6C+++HIVwOwOmlsdwXWF/ykyK9WOlq/ktIPjRslvllk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    xclip
    wl-clipboard
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Google Translate TUI (Originally). Now support Apertium, Argos, Bing, ChatGPT, DeepL, Google, Reverso";
    homepage = "https://github.com/eeeXun/gtt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "gtt";
  };
}
