{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gotmplfmt";
  version = "1.0.25";

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "gotmplfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mJkQP2nAVGqvxthrkLU4MmydPE/h+hcHM9c5/SRLj+4=";
  };

  vendorHash = "sha256-uPqabZgQGQulf+F3BvMLhv4O0h5jOq12F7K60u5xjtA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage gotmplfmt.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fmt Go HTML templates";
    homepage = "https://github.com/miekg/gotmplfmt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tetov ];
  };
})
