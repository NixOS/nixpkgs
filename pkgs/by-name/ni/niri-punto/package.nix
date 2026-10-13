{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-punto";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "qam1s";
    repo = "niri-punto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q4Jtkyh44OM/4PmeLCEq01Y5QDPpvaylygcjukybWNk=";
  };

  cargoHash = "sha256-snbTF9WvFM5v3zrGi3H18QKz0nMZ4vvuMuJ+VhDo8gs=";

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
