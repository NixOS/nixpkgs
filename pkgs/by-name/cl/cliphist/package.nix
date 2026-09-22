{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  gawk,
  wl-clipboard,
  fuzzel,
  fzf,
  chafa,
  wofi,
}:

buildGoModule (finalAttrs: {
  pname = "cliphist";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "cliphist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y4FSl/Bj80XqCR0ZwjGEkqYUIF6zJHrYyy01XPFlzjU=";
  };

  vendorHash = "sha256-4XyDLOJHdre/1BpjgFt/W6gOlPOvKztE+MsbwE3JAaQ=";

  postPatch = ''
    substituteInPlace contrib/cliphist-{fuzzel,rofi,wofi}-img \
      --replace-fail "gawk" "${lib.getExe gawk}"
    substituteInPlace contrib/cliphist-{fuzzel-img,fzf,fzf-sixel,rofi,rofi-img,wofi-img} \
      --replace-fail "wl-copy" "${lib.getExe' wl-clipboard "wl-copy"}"
    substituteInPlace contrib/cliphist-fuzzel-img \
      --replace-fail "fuzzel " "${lib.getExe fuzzel} "
    substituteInPlace contrib/cliphist-fzf{,-sixel} \
      --replace-fail "fzf " "${lib.getExe fzf} "
    substituteInPlace contrib/cliphist-fzf-sixel \
      --replace-fail "chafa " "${lib.getExe chafa} "
    substituteInPlace contrib/cliphist-wofi-img \
      --replace-fail "| wofi" "| ${lib.getExe wofi}"
  '';

  postInstall = ''
    cp ./contrib/cliphist-{fuzzel-img,fzf,fzf-sixel,rofi,rofi-img,wofi-img} $out/bin/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  buildInputs = [ bash ];

  meta = {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ klea ];
    mainProgram = "cliphist";
  };
})
