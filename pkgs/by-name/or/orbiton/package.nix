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
  version = "2.70.5";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    tag = "v${version}";
    hash = "sha256-w2t3IxWB8F2QXB0caTP/kTGum6zec5BRxK9+kYwAcDY=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = lib.optional withGui vte;

  preBuild = "cd v2";

  checkFlags =
    let
      skippedTests = [
        "TestPBcopy" # Requires impure pbcopy and pbpaste
        "TestPkill" # error: no process named "sleep" found
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
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
