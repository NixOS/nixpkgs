{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nettle,
  pkg-config,
  capnproto,
}:
rustPlatform.buildRustPackage (final: {
  pname = "sequoia-keystore-server";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-keystore";
    rev = "server/v${final.version}";
    hash = "sha256-UqlrMh1dDnykr69kR+fikx+mk9WsF9Y8jsfazKCvXV4=";
  };

  cargoHash = "sha256-uTpJzYncRQBs/mXiJylqmNw0/j4ia1MM4hhZ20g9Muw=";

  buildAndTestSubdir = "server";

  buildInputs = [ nettle.dev ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    capnproto
  ];

  postInstall = ''
    install -Dt $out/lib/sequoia $out/bin/${final.meta.mainProgram}
    rm -rf $out/bin
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-keystore";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "sequoia-keystore";
  };
})
