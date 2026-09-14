{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pingtunnel";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "esrrhs";
    repo = "pingtunnel";
    rev = finalAttrs.version;
    hash = "sha256-KBDqrpS96RHz9irNBGRTqGe7u5/FK2gPy3/h+UDgBlw=";
  };

  vendorHash = "sha256-k98rCkjML0XtYUXq6E1HuskYQ+sENE9KaqS0U197H10=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pingtunnel
  '';

  meta = {
    description = "Tool that send TCP/UDP traffic over ICMP";
    homepage = "https://github.com/esrrhs/pingtunnel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "pingtunnel";
  };
})
