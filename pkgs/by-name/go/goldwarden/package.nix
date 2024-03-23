{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
, libfido2
, dbus
, pinentry-gnome3
, nix-update-script
}:

buildGoModule rec {
  pname = "goldwarden";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "goldwarden";
    rev = "v${version}";
    hash = "sha256-4KxPtsIEW46p+cFx6yeSdNlsffy9U31k+ZSkE6V0AFc=";
  };

  vendorHash = "sha256-IH0p7t1qInA9rNYv6ekxDN/BT5Kguhh4cZfmL+iqwVU=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [makeBinaryWrapper];

  buildInputs = [libfido2];

  postInstall = ''
    wrapProgram $out/bin/goldwarden \
      --suffix PATH : ${lib.makeBinPath [dbus pinentry-gnome3]}

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
