{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  shellcheck,
  bash,
  systemd,
  coreutils,
  gawk,
  util-linux,
}:

stdenv.mkDerivation {
  pname = "nmtrust";
  version = "0.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brett";
    repo = "nmtrust-nix";
    rev = "v0.1.0";
    hash = "sha256-7Cs00mCzByTKe7w5pnkkgqtZyUSaPa2r/5Uv133eZy0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ shellcheck ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    shellcheck nmtrust.sh
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 nmtrust.sh $out/bin/nmtrust
    wrapProgram $out/bin/nmtrust \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          systemd
          coreutils
          gawk
          util-linux
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "Declarative network trust management for NixOS";
    longDescription = ''
      nmtrust evaluates the trust state of active NetworkManager connections
      and activates corresponding systemd targets. Services bound to these
      targets start and stop automatically as you move between trusted,
      untrusted, and offline networks.

      A NixOS-native reimplementation of nmtrust by Peter Hogg (pigmonkey).
    '';
    homepage = "https://github.com/brett/nmtrust-nix";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.brett ];
    mainProgram = "nmtrust";
    platforms = lib.platforms.linux;
  };
}
