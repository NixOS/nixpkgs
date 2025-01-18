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
  version = "2.68.6";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    tag = "v${version}";
    hash = "sha256-7h8U6Ye5Jyf0UmV/+6yHv9QBEtxYHlDBq+T09tmywnM=";
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

  meta = with lib; {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://orbiton.zip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "o";
  };
}
