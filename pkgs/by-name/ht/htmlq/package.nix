{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "htmlq";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mgdm";
    repo = "htmlq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kZtK2QuefzfxxuE1NjXphR7otr+RYfMif/RSpR6TxY0=";
  };

  cargoHash = "sha256-QUlR6PuOLbeAHzARtTo7Zn7fmjs2ET6TdXT4VgCYEVg=";

  doCheck = false;

  meta = {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/mgdm/htmlq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      siraben
      nerdypepper
    ];
    mainProgram = "htmlq";
  };
})
