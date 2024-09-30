{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-Kpe/LiAreZXRqh6BHvUIn0GcHloKo3A0WOdlRF2ygdc=";
  };

  vendorHash = "sha256-Hdr9NRqHJxpfrV2G1KuHGg3T+cPLKhZXEW02f1ptgsw=";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };
}
