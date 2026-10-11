{
  lib,
  stdenv,
  fetchgit,
  makeWrapper,
  coreutils,
  fish,
  jq,
  nix,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixpkgs-whereis";
  version = "1.2.3";

  src = fetchgit {
    url = "https://git.envs.net/binarycat/nixpkgs-whereis.git";
    rev = finalAttrs.version;
    hash = "sha256-CZokiob077hNf/ipKWQL1bo+8dXoLcpT748xFoQRMbI=";
  };

  nativeBuildInputs = [
    fish
    makeWrapper
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    patchShebangs $out/bin/nixpkgs-whereis
  '';

  postFixup = ''
    wrapProgram $out/bin/nixpkgs-whereis \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          fish
          jq
          nix
        ]
      }
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "nixpkgs-whereis --version";
  };

  meta = {
    description = "Simple command to check where in nixpkgs an attribute is defined";
    homepage = "https://git.envs.net/binarycat/nixpkgs-whereis";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nettika ];
    mainProgram = "nixpkgs-whereis";
    platforms = lib.platforms.unix;
  };
})
