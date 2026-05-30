{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lexido";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "micr0-dev";
    repo = "lexido";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zJP14dbC/Oz15CA3PRD0RfEYOrfulL2fWYHwFxhLKO4=";
  };

  vendorHash = "sha256-H5qljaA77AQrUjFsVSWha5pzt4qS9XKagG4GoNRVn88=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Terminal assistant, powered by Generative AI";
    homepage = "https://github.com/micr0-dev/lexido";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "lexido";
  };
})
