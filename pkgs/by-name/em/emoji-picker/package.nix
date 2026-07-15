{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "emoji-picker";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bcongdon";
    repo = "ep";
    rev = finalAttrs.version;
    hash = "sha256-ElUsmuJ43kOsu4cGvNytM+xHTfuzMo0jcG8Z1cIeHJs=";
  };

  patches = [ ./xsys.patch ];

  vendorHash = "sha256-Xeh5JKIBiyOXRGVx9udoUNs+Wv49BMyFvmnAbDfG3rA=";

  meta = {
    description = "CLI Emoji Picker";
    homepage = "https://github.com/bcongdon/ep";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ep";
  };
})
