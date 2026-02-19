{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "errcheck";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DhOoJL4InJHl4ImIrhV086a++srC5E4LF2VQb838+L8=";
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
