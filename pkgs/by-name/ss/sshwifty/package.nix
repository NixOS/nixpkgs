{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  go,
}:
buildGoModule (finalAttrs: {
  pname = "sshwifty";
  version = "0.3.25-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-gcr/l3fV7s1cwoTGrdMiT1JyxxQOGLrY1qHOBt9oy3w=";
  };

  sshwifty-ui = buildNpmPackage {
    pname = "sshwifty-ui";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-Suo678zynlRqcsY5G0LL4hailRjyi7TWwO5Xs3ACKKI=";

    npmBuildScript = "generate";

    postInstall = ''
      cp -r application/controller/{static_pages,static_pages.go} \
        $out/lib/node_modules/sshwifty-ui/application/controller
    '';

    nativeBuildInputs = [ go ];
  };

  postPatch = ''
    cp -r ${finalAttrs.sshwifty-ui}/lib/node_modules/sshwifty-ui/* .
  '';

  vendorHash = "sha256-tmbAsN0T1rXGvLWlx7c7AKnq4dquSPmfjaRxn3+ve+k=";

  ldflags = [
    "-s -w -X github.com/nirui/sshwifty/application.version=${finalAttrs.version}"
  ];

  postInstall = ''
    find $out/bin ! -name sshwifty -type f -exec rm -rf {} \;
  '';

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
