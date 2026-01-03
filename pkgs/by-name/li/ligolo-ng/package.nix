{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkgsCross ? { },
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ligolo-ng";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "nicocha30";
    repo = "ligolo-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ND0SFB0xj4WK6okNzChZWfK5bhNc4PTWuZoq/PodTW0=";
  };

  vendorHash = "sha256-oc85xNPMFeaPC7TMcSh3i3Msd8sCJ5QGFmi2fKjcyvk=";

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/agent"
    "cmd/proxy"
  ];

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
    "-X main.version=${finalAttrs.version}"
  ];

  # This will prefix all the binaries with ligolo-
  postInstall = ''
    for f in $out/bin/*; do
      mv "$f" "$(dirname "$f")/ligolo-$(basename "$f")"
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/ligolo-agent";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      win = pkgsCross.mingwW64.ligolo-ng or null;
      linux64 = pkgsCross.gnu64.ligolo-ng or null;
    };
    updateScript = nix-update-script { };
  };

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Advanced TUN-based tunneling/pivoting tool";
    homepage = "https://github.com/nicocha30/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ letgamer ];
    platforms = lib.platforms.linux ++ lib.platforms.windows;
  };
})
