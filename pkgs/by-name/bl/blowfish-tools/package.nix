{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  hugo,
}:

buildNpmPackage (finalAttrs: {
  pname = "blowfish-tools";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "nunocoracao";
    repo = "blowfish-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-90EKsRKOO2Hb64Wy3TlwzlPU2K8AAlSxc17ek5ZLoG0=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-P6XHXR4QcVCRz5ju36OzCTNxXtW9RYxkfhbp7kJVfoY=";

  postFixup = ''
    wrapProgram $out/bin/blowfish-tools \
      --prefix PATH : ${lib.makeBinPath [ hugo ]}
  '';

  meta = {
    description = "CLI to initialize and configure a Blowfish project";
    homepage = "https://blowfish.page";
    changelog = "https://github.com/nunocoracao/blowfish-tools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eripa ];
    mainProgram = "blowfish-tools";
  };
})
