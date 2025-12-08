{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gotmplfmt";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "gotmplfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-87TcSEV4tJXf7a9Sml5H7mdVGYd4z7yJRxdkZFYm5DQ=";
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
