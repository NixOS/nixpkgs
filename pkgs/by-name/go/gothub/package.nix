{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "gothub";
  version = "0-unstable-2026-04-06";
  rev = "0bc0ec59222bfb09fb29fec4136133e220072285";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    inherit (finalAttrs) rev;

    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    hash = "sha256-Q5CF7wpmxtoubK/sqmDteEJh0qba8TXoN4NB/T9zu08=";
  };

  vendorHash = "sha256-tv1A2VUbTZHsonQe6Zxwh6hWR6w5lbbSCgVy6n0qJe0=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/gothub/gothub/utils.Branch=master"
  ];

  postInstall = ''
    install -d $out/share/${finalAttrs.pname}
    cp -r views public $out/share/${finalAttrs.pname}/

    wrapProgram $out/bin/${finalAttrs.pname} \
      --chdir "$out/share/${finalAttrs.pname}"
  '';

  meta = {
    description = "Alternative privacy-friendly frontend for GitHub";
    longDescription = ''
      GotHub is a lightweight, JavaScript-free frontend for GitHub that keeps
      requests to GitHub server-side.
    '';
    homepage = "https://codeberg.org/${finalAttrs.pname}/${finalAttrs.pname}";
    changelog = "https://codeberg.org/${finalAttrs.pname}/${finalAttrs.pname}/compare/a54bf8c21760edad18f2b07d40090df75382eccb...${finalAttrs.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = finalAttrs.pname;
  };
})
