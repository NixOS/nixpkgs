{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  withGui ? true,
  vte,
}:

buildGoModule rec {
  pname = "orbiton";
  version = "2.68.8";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    tag = "v${version}";
    hash = "sha256-EYUhiKza2zdlgigQcFwTau2graR0Re1X/zI4kEjsZyc=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = lib.optional withGui vte;

  preBuild = "cd v2";

  checkFlags = [
    "-skip=TestPBcopy" # Requires impure pbcopy and pbpaste
  ];

  postInstall =
    ''
      cd ..
      installManPage o.1
      mv $out/bin/{orbiton,o}
    ''
    + lib.optionalString withGui ''
      make install-gui PREFIX=$out
      wrapProgram $out/bin/og --prefix PATH : $out/bin
    '';

  meta = {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://roboticoverlords.org/orbiton/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "o";
  };
}
