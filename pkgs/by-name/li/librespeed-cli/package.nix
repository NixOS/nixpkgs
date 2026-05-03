{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "librespeed-cli";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q6JdkXl6EaM/Uh2u2xH4Afa+aFvssZh98J7uUtJv/H0=";
  };

  vendorHash = "sha256-LXSCOAX3EwDBJ37mkS/BZCllgEai8tC7WFy6pebNAyo=";

  # Tests have additional requirements
  doCheck = false;

  postInstall = ''
    mv $out/bin/speedtest-cli $out/bin/librespeed-cli
  '';

  meta = {
    description = "Command line client for LibreSpeed";
    homepage = "https://github.com/librespeed/speedtest-cli";
    changelog = "https://github.com/librespeed/speedtest-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "librespeed-cli";
  };
})
