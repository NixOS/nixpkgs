{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "dssd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ylxdzsw";
    repo = "dssd";
    rev = "v${version}";
    hash = "sha256-ExVL7og7uWGAAYTwESzr/2iDWhemovDhJINPEQoHk7c=";
  };

  # https://github.com/ylxdzsw/dssd/issues/7
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock

    substituteInPlace dssd.service org.freedesktop.secrets.service \
      --replace-fail /usr/bin/dssd $out/bin/dssd
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  postInstall = ''
    install dssd.service -Dt $out/lib/systemd/user/
    install org.freedesktop.secrets.service -Dt $out/share/dbus-1/system-services/
  '';

  meta = {
    description = "Dead Simple Secret Daemon";
    homepage = "https://github.com/ylxdzsw/dssd/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "dssd";
  };
}
