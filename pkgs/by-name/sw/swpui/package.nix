{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swpui";
  version = "0.10.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "swpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VbwaZKni5no+ei7fXi14QUJMjL6PHB2ck0n50kQMlaw=";
  };

  cargoHash = "sha256-rrC0TUbFjlWjdUEa+aYtirjXUSuc83bl4uGX6Tkr37M=";

  meta = {
    description = "TUI utility to search and replace with a focus on ergonomics, speed and case-awareness";
    homepage = "https://github.com/beeb/swpui";
    changelog = "https://github.com/beeb/swpui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "swp";
  };
})
