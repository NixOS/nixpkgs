{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "crawley";
  version = "1.7.19";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d854JL2/ZhEKQUG8tJ7TctDaicWnAKEFl0mJF6MIvls=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-lptFxIt5b7d6hIXdAqakA1K78NGJ86u0p/XfbQMiTsc=";

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
