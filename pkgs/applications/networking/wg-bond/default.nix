{ pkgs, lib, rustPlatform, fetchFromGitLab, wireguard-tools, makeWrapper }:
rustPlatform.buildRustPackage rec {
  pname = "wg-bond";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "cab404";
    repo = "wg-bond";
    rev = "v${version}";
    hash = "sha256:04k0maxy39k7qzcsqsv1byddsmjszmnyjffrf22nzbvml83p3l0y";
  };

  cargoSha256 = "09ipziznpy8zy22pfnbmjz9zr0683px98c4nf7kgrl5hs3fqvh5g";

  buildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/wg-bond --set PATH ${
      lib.makeBinPath [ wireguard-tools ]
    }
  '';

  meta = with lib; {
    description = "Wireguard configuration manager";
    homepage = "https://gitlab.com/cab404/wg-bond";
    changelog = "https://gitlab.com/cab404/wg-bond/-/releases#v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cab404 ];
  };
}
