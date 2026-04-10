{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protolock";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "nilslice";
    repo = "protolock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+7kU4nCBwCA6mnjFrejPrIILYUSfYpq13d+0MmNZoBg=";
  };

  vendorHash = "sha256-lJhtZQ9S7/h3dSZ72O2l8oHHf3tEmGKC2PPAms09Itc=";

  postInstall = ''
    rm $out/bin/plugin*
  '';

  meta = {
    description = "Protocol Buffer companion tool. Track your .proto files and prevent changes to messages and services which impact API compatibility. https://protolock.dev";
    mainProgram = "protolock";
    homepage = "https://github.com/nilslice/protolock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ groodt ];
  };
})
