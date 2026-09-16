{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-YdnqD/4A3+Ob1cMyQvnHe8MzUfHQNdB3ltrXvQXNRmg=";
  };

  cargoHash = "sha256-qUzC1FMkeD04RbOdSstINvOj92gdfpTq1kjT4Xb/2J4=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
  };
})
