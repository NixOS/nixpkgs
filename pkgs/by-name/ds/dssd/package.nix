{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dssd";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "ylxdzsw";
    repo = "dssd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gAV4gwrfvYfc2f1tDY/cNOFMrQzrzHSmEFsKg7ke/6c=";
  };

  cargoHash = "sha256-yX2/2TW3FNbqwzR6+5yP26E2Eps0bTJgJJrDIQG2KQU=";

  postPatch = ''
    substituteInPlace dssd.service org.freedesktop.secrets.service \
      --replace-fail /usr/bin/dssd $out/bin/dssd
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  postInstall = ''
    install dssd.service -Dt $out/lib/systemd/user/
    install org.freedesktop.secrets.service -Dt $out/share/dbus-1/system-services/
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Dead Simple Secret Daemon";
    homepage = "https://github.com/ylxdzsw/dssd";
    license = lib.licenses.mit;
    mainProgram = "dssd";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux;
  };
})
