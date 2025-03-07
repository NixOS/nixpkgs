{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

let
  version = "0.16.10";
in
buildGoModule {
  pname = "mrpack-install";
  inherit version;

  src = fetchFromGitHub {
    owner = "nothub";
    repo = "mrpack-install";
    tag = "v${version}";
    hash = "sha256-mTAXFK97t10imdICpg0UI4YLF744oscJqoOIBG5GEkc=";
  };

  vendorHash = "sha256-az+NpP/hCIq2IfO8Bmn/qG3JVypeDljJ0jWg6yT6hks=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # Fetches metadata from the internet, which fails while sandboxed

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd mrpack-install \
      --bash <($out/bin/mrpack-install completion bash) \
      --fish <($out/bin/mrpack-install completion fish) \
      --zsh <($out/bin/mrpack-install completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI application for installing Minecraft servers and Modrinth modpacks";
    homepage = "https://github.com/nothub/mrpack-install";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ encode42 ];
    mainProgram = "mrpack-install";
  };
}
