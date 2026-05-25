{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-libp2p-daemon";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nXDUXf4ox6h8T9v9brktnHHfv7SfIsDW304Iat0s86E=";
  };

  vendorHash = "sha256-WOk06En90ys0pe5OZwhXCJJwry77t13eWg131fnQvpw=";

  doCheck = false;

  meta = {
    description = "Libp2p-backed daemon wrapping the functionalities of go-libp2p for use in other languages";
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fare ];
  };
})
