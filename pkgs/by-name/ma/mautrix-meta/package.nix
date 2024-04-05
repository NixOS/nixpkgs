{ lib, buildGoModule, fetchFromGitHub, olm, config }:

buildGoModule rec {
  pname = "mautrix-meta";
  version = "0.2.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    rev = "v${version}";
    hash = "sha256-n0FpEHgnMdg6W5wahIT5HaF9AP/QYlLuUWJS+VrElgg=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-GkgIang3/1u0ybznHgK1l84bEiCj6u4qf8G+HgLGr90=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/mautrix/meta";
    description = "Matrix <-> Facebook and Mautrix <-> Instagram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ rutherther ];
    mainProgram = "mautrix-meta";
  };
}
