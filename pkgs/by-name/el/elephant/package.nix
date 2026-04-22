{
  # list of providers to enable, all are enabled by default
  # e.g. enabledProviders = ["files"] will only install the files provider
  enabledProviders ? null,

  bluez,
  buildGoModule,
  fd,
  fetchFromGitHub,
  imagemagick,
  lib,
  libqalculate,
  makeWrapper,
  nix-update-script,
  protobuf,
  protoc-gen-go,
  wl-clipboard,
}:
let
  providerEnabled = provider: (enabledProviders == null) || lib.elem provider enabledProviders;

  runtimeDeps =
    lib.optionals (providerEnabled "files") [ fd ]
    ++ lib.optionals (providerEnabled "bluetooth") [ bluez ]
    ++ lib.optionals (providerEnabled "calc") [ libqalculate ]
    ++ lib.optionals (providerEnabled "clipboard") [
      wl-clipboard
      imagemagick
    ];

in
buildGoModule (finalAttrs: {
  pname = "elephant";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "elephant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h7Rw0vlb0n0Jsk21WJPm7H+1T1bG+PEuxE5cJ2TZl8A=";
  };

  vendorHash = "sha256-EWXZ+9/QDRpidpVHBcfJgp0xoc3YtRsiC/UTk1R+FSY=";

  buildInputs = [ protobuf ];
  nativeBuildInputs = [
    makeWrapper
    protoc-gen-go
  ];

  subPackages = [ "cmd/elephant" ];

  postBuild =
    (
      if enabledProviders == null then
        ''
          PROVIDERS=()
          for x in internal/providers/*/; do
            PROVIDERS+=("$(basename "$x")")
          done
        ''
      else
        ''
          PROVIDERS=(${lib.escapeShellArgs enabledProviders})
        ''
    )
    + ''
      echo "Installing providers"
      mkdir -p $out/lib/elephant/providers
      for provider in "''${PROVIDERS[@]}"; do
        [ -z "$provider" ] && continue
        if [ -d "internal/providers/$provider" ]; then
          echo "Building provider: $provider"
          go build -buildmode=plugin -o "$out/lib/elephant/providers/$provider.so" ./internal/providers/"$provider" || exit 1
        fi
      done
    '';

  postInstall = ''
    wrapProgram $out/bin/elephant \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set ELEPHANT_PROVIDER_DIR "$out/lib/elephant/providers"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Data provider service and backend for building custom application launchers";
    changelog = "https://github.com/abenz1267/elephant/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/abenz1267/elephant";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      adamcstephens
      saadndm
    ];
    mainProgram = "elephant";
  };
})
