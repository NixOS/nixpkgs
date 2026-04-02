{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "crawley";
  version = "1.7.18";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fopIRHaHiLYLA6/WHuY18Y91vF/BOPs0dHE7KCFXtj4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-0CGkRyW353JD04f0/F5dcRCD6YE5DXYaNetEx8moAGY=";

  ldflags = [
    "-w"
    "-s"
  ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

  meta = {
    description = "Unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ltstf1re ];
    mainProgram = "crawley";
  };
})
