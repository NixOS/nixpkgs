{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  procps,
  iproute2,
  iptables,
  openresolv,
  amneziawg-go,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amneziawg-tools";
  version = "1.0.20241018";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-tools";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-y6xkOLT9KVD6ACCH60Myk2iA1S8/+tGXEQbOYnu+dPI=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX=/"
    "WITH_BASHCOMPLETION=yes"
    "WITH_SYSTEMDUNITS=yes"
    "WITH_WGQUICK=yes"
  ];

  postFixup =
    ''
      substituteInPlace $out/lib/systemd/system/awg-quick@.service \
        --replace-fail /usr/bin $out/bin
    ''
    + lib.optionalString stdenv.isLinux ''
      for f in $out/bin/*; do
        # Which firewall and resolvconf implementations to use should be determined by the
        # environment, we provide the "default" ones as fallback.
        wrapProgram $f \
          --prefix PATH : ${
            lib.makeBinPath [
              procps
              iproute2
            ]
          } \
          --suffix PATH : ${
            lib.makeBinPath [
              iptables
              openresolv
            ]
          }
      done
    ''
    + lib.optionalString stdenv.isDarwin ''
      for f in $out/bin/*; do
        wrapProgram $f \
          --prefix PATH : ${lib.makeBinPath [ amneziawg-go ]}
      done
    '';

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for configuring AmneziaWG";
    homepage = "https://amnezia.org";
    changelog = "https://github.com/amnezia-vpn/amneziawg-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.unix;
    mainProgram = "awg";
  };
})
