{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, oo7
, openssl
, pkg-config
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "oo7";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "oo7";
    rev = version;
    hash = "sha256-oNzDjPMPM8opINSHC8T4ivQ6mfRVmN2VXPZAFkBZS8U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    install -Dm644 portal/data/oo7-portal.portal $out/share/xdg-desktop-portal/portals/oo7.portal
    install -Dm644 portal/data/oo7-portal.service $out/share/dbus-1/services/oo7-portal.service
    substituteInPlace $out/share/dbus-1/services/oo7-portal.service \
      --replace-fail "@bindir@" "$out/bin"
  '';

  passthru = {
    tests.testVersion = testers.testVersion {
      package = oo7;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "James Bond went on a new mission as a Secret Service provider";
    homepage = "https://github.com/bilelmoussaoui/oo7";
    license = licenses.mit;
    maintainers = with maintainers; [ getchoo Scrumplex ];
    platforms = platforms.linux;
    mainProgram = "oo7-cli";
  };
}
