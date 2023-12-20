{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
, installShellFiles
, snippetexpanderd
}:

buildGoModule rec {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpander";

  vendorHash = "sha256-wSAho59yxcXTu1zQ5x783HT4gtfSM4GdsOEeC1wfHhE=";

  proxyVendor = true;

  modRoot = "cmd/snippetexpander";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  buildInputs = [
    snippetexpanderd
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    make man
    installManPage snippetexpander.1
  '';

  meta = with lib; {
    description = "Your little expandable text snippet helper CLI";
    homepage = "https://snippetexpander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
    mainProgram = "snippetexpander";
  };
}
