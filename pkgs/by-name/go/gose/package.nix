{
  buildGoModule,
  buildNpmPackage,
  nix-update-script,
  versionCheckHook,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.9.0";

  src = fetchFromGitHub {
    repo = "gose";
    owner = "stv0g";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vcp9gMJ296KS8OFOIcWvvYrS+LrOVlN3KN20yJxoo5U=";
  };

  frontend = buildNpmPackage {
    pname = "gose-frontend";
    inherit version;
    src = "${src}/frontend";

    npmDepsHash = "sha256-p24s2SgCL8E9vUoZEyWSrd15IdkprneAXS7dwb7UbyA=";

    installPhase = ''
      runHook preInstall
      find ./dist
      mkdir $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "gose";
  inherit version;
  inherit src;

  vendorHash = "sha256-U/umJ6McCuD0HARVMj1JXHOpVxcph16z7Y7i47Nf3cg=";

  env.CGO_ENABLED = 0;

  postInstall = ''
    mv $out/bin/cmd $out/bin/gose
  '';

  tags = [ "embed" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=Nix"
  ];

  # Skipping test which relies on internet services.
  checkFlags = "-skip TestShortener";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  prePatch = ''
    cp -r ${frontend} frontend/dist
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern and scalable file-uploader focusing on scalability and simplicity";
    homepage = "https://github.com/stv0g/gose";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stv0g ];
    mainProgram = "gose";
  };
}
