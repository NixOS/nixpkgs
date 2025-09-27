{
  lib,
  buildGo125Module,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
  go_1_25,
}:
buildGo125Module (finalAttrs: {
  pname = "sshwifty";
  version = "0.4.0-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-7ZfS46+aflKIQ8S9T18JjCb7bY8mB6cJl/lgJi5Hukg=";
  };

  sshwifty-ui = buildNpmPackage {
    pname = "sshwifty-ui";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-I96VixL21cF2kp9AK6q0ipjphjdWuSETKakbsprGek0=";

    npmBuildScript = "generate";

    postInstall = ''
      cp -r application/controller/{static_pages,static_pages.go} \
        $out/lib/node_modules/sshwifty-ui/application/controller
    '';

    nativeBuildInputs = [ go_1_25 ];
  };

  postPatch = ''
    cp -r ${finalAttrs.sshwifty-ui}/lib/node_modules/sshwifty-ui/* .
  '';

  vendorHash = "sha256-kLKydjvZtFEY7vjqxK1cCwZSTbdqYWPRmxYSN0LYqsg=";

  ldflags = [
    "-s"
    "-X github.com/nirui/sshwifty/application.version=${finalAttrs.version}"
  ];

  postInstall = ''
    find $out/bin ! -name sshwifty -type f -exec rm -rf {} \;
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) sshwifty; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "WebSSH & WebTelnet client";
    homepage = "https://github.com/nirui/sshwifty";
    changelog = "https://github.com/nirui/sshwifty/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
})
