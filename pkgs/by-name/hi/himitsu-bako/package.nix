{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fzf,
  makeWrapper,
  stdenv,
  wl-clipboard,
  xclip,
  xsel,
}:

buildGoModule (finalAttrs: {
  pname = "himitsu-bako";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "shichirouji21";
    repo = "himitsu-bako";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8wQ0n3Xy5nnouDGMUfeM5eCiz+nthKzHvYa/Z+L43Go=";
  };

  vendorHash = "sha256-jwQvAIS8XCWjZtP9pKt1RRSaKBZ9dgDc2SD6q0K+sEs=";

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/himitsu-bako \
      --prefix PATH : ${
        lib.makeBinPath (
          [ fzf ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            wl-clipboard
            xclip
            xsel
          ]
        )
      }
  '';

  meta = {
    description = "Encrypted clipboard-backed secret storage using age";
    homepage = "https://github.com/shichirouji21/himitsu-bako";
    changelog = "https://github.com/shichirouji21/himitsu-bako/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ shichirouji21 ];
    mainProgram = "himitsu-bako";
    platforms = lib.platforms.unix;
  };
})
