{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-punto";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "qam1s";
    repo = "niri-punto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-twPWIjaM/NfkaLzucUWe/gQ+hzpW53MPtGs7+7Vtz0k=";
  };

  cargoHash = "sha256-Wqnv0fgMcixsKVuZlnHnwAN0lFD8FCaqgFndNW8RERQ=";

  __structuredAttrs = true;

  postInstall = ''
    install -Dm644 contrib/70-niri-punto.rules $out/lib/udev/rules.d/70-niri-punto.rules
    install -Dm644 contrib/niri-punto.service $out/lib/systemd/user/niri-punto.service
    substituteInPlace $out/lib/systemd/user/niri-punto.service \
      --replace-fail "@@NIRI_PUNTO_EXE@@" "$out/bin/niri-punto"
  '';

  meta = with lib; {
    description = "Keyboard layout corrector for the niri Wayland compositor";
    homepage = "https://github.com/qam1s/niri-punto";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.qam1s ];
    mainProgram = "niri-punto";
    platforms = platforms.linux;
  };
})
