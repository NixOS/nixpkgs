{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hydroxide";
  version = "0.2.32";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hydroxide";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3cSJkNTD5+L3VXO5I/1xo1tp9+H4/Z/tc2f8B63lGrc=";
  };

  vendorHash = "sha256-BIHvURCgqEzhl4NsVB7vBwLqMPxkM3CQgHmIcSTdOE4=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = {
    description = "Third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = lib.licenses.mit;
    mainProgram = "hydroxide";
  };
})
