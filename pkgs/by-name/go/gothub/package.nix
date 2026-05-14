{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "gothub";
  version = "0-unstable-2026-10-14";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "gothub";
    repo = "gothub";
    rev = "1cd6bb46a45beac9dd8124aa82bd2e8d411d2962";
    hash = "sha256-7EKklEM9N1BUo8uYrGuzh0yelBebtkE6Lg8PGRFrmVQ=";
  };

  vendorHash = "sha256-r1SvuSOu3isxdkh2oeIJDUyCXekDBSYKOqzdQz89Fxg=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/gothub/gothub/utils.Branch=master"
  ];

  postInstall = ''
    install -d $out/share/gothub
    cp -r views public $out/share/gothub/

    wrapProgram $out/bin/gothub \
      --chdir "$out/share/gothub" \
      --set-default GOTHUB_SETUP_COMPLETE true
  '';

  meta = {
    description = "Alternative privacy-friendly frontend for GitHub";
    longDescription = ''
      GotHub is a lightweight, JavaScript-free frontend for GitHub that keeps
      requests to GitHub server-side.
    '';
    homepage = "https://codeberg.org/gothub/gothub";
    changelog = "https://codeberg.org/gothub/gothub/compare/a54bf8c21760edad18f2b07d40090df75382eccb...${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "gothub";
  };
})
