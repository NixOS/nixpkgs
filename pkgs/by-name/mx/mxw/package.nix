{
  cargo,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
  rustPlatform,
  systemd,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "mxw";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "dkbednarczyk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iac7MpZASdmgh4bEobBLA6iMb2GhW6SqOzHMpVD8eWw=";
  };

  nativeBuildInputs = [pkg-config];

  buildInputs = [cargo systemd];

  cargoHash = "sha256-LBrWBrdY6c5U9SIQEPNC5tE3d3bffeuZndFPwxtEetA=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "";
    homepage = "https://github.com/dkbednarczyk/mxw";
    license = licenses.mit;
    maintainers = with maintainers; [imadnyc];
    platforms = platforms.linux;
  };
}
