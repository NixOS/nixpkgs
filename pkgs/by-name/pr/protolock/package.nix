{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protolock";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${version}";
    sha256 = "sha256-+7kU4nCBwCA6mnjFrejPrIILYUSfYpq13d+0MmNZoBg=";
  };

  vendorHash = "sha256-lJhtZQ9S7/h3dSZ72O2l8oHHf3tEmGKC2PPAms09Itc=";

  postInstall = ''
    rm $out/bin/plugin*
  '';

<<<<<<< HEAD
  meta = {
    description = "Protocol Buffer companion tool. Track your .proto files and prevent changes to messages and services which impact API compatibility. https://protolock.dev";
    mainProgram = "protolock";
    homepage = "https://github.com/nilslice/protolock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ groodt ];
=======
  meta = with lib; {
    description = "Protocol Buffer companion tool. Track your .proto files and prevent changes to messages and services which impact API compatibility. https://protolock.dev";
    mainProgram = "protolock";
    homepage = "https://github.com/nilslice/protolock";
    license = licenses.bsd3;
    maintainers = with maintainers; [ groodt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
