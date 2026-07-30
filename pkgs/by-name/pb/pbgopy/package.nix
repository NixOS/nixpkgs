{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pbgopy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "pbgopy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rm4fopreiYBwcFbtuo0B6FalveFft8hrNVf7JpvyNKE=";
  };

  vendorHash = "sha256-qxdylBQiUlHOkzaxV+P9m3tnkFqUdZTdF31LD0IWyuI=";

  meta = {
    description = "Copy and paste between devices";
    mainProgram = "pbgopy";
    homepage = "https://github.com/nakabonne/pbgopy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
