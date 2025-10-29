{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "aws-assume-role";
  version = "0.3.2";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "remind101";
    repo = "assume-role";
    tag = version;
    sha256 = "sha256-7+9qi9lYzv1YCFhUyla+5Gqs5nBUiiazhFwiqHzMFd4=";
  };

  deleteVendor = true;

  vendorHash = "sha256-NIY6w/hQQ357KHEDEHUYVLbkQKsm8FLtRf3/AbbgukA=";

  patches = [
    # Generate with go mod init github.com/remind101/assume-role && go mod tidy
    ./0001-add-go.mod-go.sum.patch
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/aws-assume-role README.md
  '';

  meta = with lib; {
    description = "Easily assume AWS roles in your terminal";
    homepage = "https://github.com/remind101/assume-role";
    license = licenses.bsd2;
    mainProgram = "assume-role";
    maintainers = with lib.maintainers; [ averyvigolo ];
    platforms = platforms.all;
  };
}
