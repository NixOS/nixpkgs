{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "errcheck";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aiZAFNTaXSzVOBhcMGc6Mxj208V7WxCbDYKqItBg3lc=";
  };

  vendorHash = "sha256-znkT0S13wCB47InP2QBCZqeWxDdEeIwQPoVWoxiAosQ=";

  subPackages = [ "." ];

  meta = {
    description = "Checks for unchecked errors in go programs";
    mainProgram = "errcheck";
    homepage = "https://github.com/kisielk/errcheck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
