{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fofax";
  version = "0.1.47";

  src = fetchFromGitHub {
    owner = "xiecat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DNidfQjehWn+/aFhfEHr2l39UVvCSv+5jNZyOLWxTbc=";
  };

  vendorHash = null;

  modRoot = "cmd/fofax";

  meta = {
    description = "FOFAX is an API cli tool for fofa.info";
    homepage = "https://github.com/xiecat/fofax";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      1235467
    ];
  };
}
