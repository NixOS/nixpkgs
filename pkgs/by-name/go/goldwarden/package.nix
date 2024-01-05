{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
, libfido2
, dbus
, pinentry
, nix-update-script
}:

buildGoModule rec {
  pname = "goldwarden";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "goldwarden";
    rev = "v${version}";
    hash = "sha256-OXJovoJ2+YIMqzoG6J2LlxUC5DMZRAdEl+ZEv6PDXlI=";
  };

  vendorHash = "sha256-1Px60+f23qoP5eEOUC3WG5vKJYjbD3bPOrDyBpXlMT0=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [makeBinaryWrapper];

  buildInputs = [libfido2];

  postInstall = ''
    wrapProgram $out/bin/goldwarden \
      --suffix PATH : ${lib.makeBinPath [dbus pinentry]}

    install -Dm644 $src/resources/com.quexten.goldwarden.policy -t $out/share/polkit-1/actions
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "A feature-packed Bitwarden compatible desktop integration";
    homepage = "https://github.com/quexten/goldwarden";
    license = licenses.mit;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "goldwarden";
    platforms = platforms.linux; # Support for other platforms is not yet ready, see https://github.com/quexten/goldwarden/issues/4
  };
}
