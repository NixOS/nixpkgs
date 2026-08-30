{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  prettier,
  bun,
  nodejs,
}:

buildGoModule (finalAttrs: {
  pname = "jxscout";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "francisconeves97";
    repo = "jxscout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jAtij9VJFYISXibmes+oO/Hh1MoEThkqfzmBe+z1RqQ=";
  };

  subPackages = [ "cmd/jxscout" ];

  vendorHash = null;

  nativeBuildInputs = [ makeWrapper ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/jxscout --prefix PATH : ${
      lib.makeBinPath [
        prettier
        bun
        nodejs
      ]
    }
  '';

  meta = {
    description = "jxscout superpowers JavaScript analysis for security researchers (free version)";
    homepage = "https://jxscout.app/";
    downloadPage = "https://github.com/francisconeves97/jxscout";
    changelog = "https://github.com/francisconeves97/jxscout/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "jxscout";
    maintainers = with lib.maintainers; [ katok ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
  };
})
