{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "promxy";
  version = "0.0.97";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jacksontj";
    repo = "promxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zg27L3O4/AN/FxsERYzSGvAWsp7fNAbcxeZdRuh0fOE=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/promxy"
  ];

  tags = [
    "builtinassets"
    "netgo"
  ];

  meta = {
    description = "Aggregating proxy to enable HA prometheus";
    homepage = "https://github.com/jacksontj/promxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
