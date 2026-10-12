{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule (finalAttrs: {
  pname = "gorace";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/MatheusBrunheroto/gorace/releases/download/v${finalAttrs.version}/gorace-${finalAttrs.version}.tar.gz";
    hash = "sha256-9Nc4CDi5qneBaYIUjvhXiFc+KCM5ZrFW/2XBNXQ/FZc=";
  };

  vendorHash = "sha256-uy8/F8FW2cqte7O7KS1x89Jy3uEdiyGz41h1emyQ72E=";

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];

  postInstall = ''
    install -Dm644 README.md "$out/share/doc/gorace/README.md"
    install -Dm644 assets/help.txt "$out/share/doc/gorace/help.txt"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/gorace" --help > help.txt
    grep -F 'GORACE(1)' help.txt
    runHook postInstallCheck
  '';

  meta = {
    description = "HTTP race condition testing tool";
    homepage = "https://github.com/MatheusBrunheroto/gorace";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gorace";
    maintainers = with lib.maintainers; [ matheusbrunheroto ];
  };
})
