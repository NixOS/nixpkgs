{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  libpulseaudio,
  cef-binary,
  nix-update-script,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  # Upstream's CEF build adds H.264/AAC and fixes high idle CPU use.
  cef = cef-binary.overrideAttrs (
    finalAttrs: _: {
      pname = "karere-cef";
      # Keep in sync with cef-dll-sys in Cargo.lock.
      version = "156.0.26";

      src = fetchzip {
        url = "https://github.com/tobagin/karere/releases/download/cef-${finalAttrs.version}-proprietary-codecs-2/cef_binary_${finalAttrs.version}%2Bg8ea0c73%2Bchromium-156.0.8078.88_${
          selectSystem {
            aarch64-linux = "linuxarm64";
            x86_64-linux = "linux64";
          }
        }_minimal.zip";
        hash = selectSystem {
          aarch64-linux = "sha256-3JefVpz37jvrL8JHKg72GRclyDHaC5Tq/NcZMN40rbo=";
          x86_64-linux = "sha256-/BXr9BWvOpinl1tG9Dr8LqUC5U5MvK58DI5d4GA4XI8=";
        };
      };

      # Flat layout with archive.json, as cef-dll-sys expects in CEF_PATH. CEF
      # looks up its resources next to libcef.so.
      postInstall = ''
        find $out -mindepth 1 -delete
        mv Release/* Resources/* include $out/
        echo '{"type":"minimal","name":"cef_binary_${finalAttrs.version}","sha1":""}' > $out/archive.json
        patchelf --add-rpath "${lib.makeLibraryPath [ libpulseaudio ]}" $out/libcef.so
      '';

      stripDebugList = [ "." ];
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "karere";
  version = "4.6.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tobagin";
    repo = "karere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-le+zl6X8RQTgJxejyfXAlpAABz70DpoOtMchfizo7hI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cG/d6CLYnkQqFxG78mOjLABRygTJkcqjaF7T8unGViM=";
  };

  # Upstream targets Flatpak, so point its /app and development paths at $out.
  postPatch = ''
    # Always take the Flatpak branch for the locale directory, as the other
    # branch looks in ./locale relative to the working directory.
    substituteInPlace src/main.rs \
      --replace-fail 'std::env::var("FLATPAK_ID").is_ok()' 'true' \
      --replace-fail '"/app/share/karere/locale"' "\"$out/share/locale\""
    substituteInPlace src/actions.rs \
      --replace-fail '"/usr".into()' "\"$out\".into()"

    # The v3 data purge deletes shared directories outside Flatpak.
    # https://github.com/tobagin/karere/issues/211
    substituteInPlace src/accounts.rs \
      --replace-fail 'data.join("webkitgtk-6.0"),' "" \
      --replace-fail 'cache.join("webkitgtk-6.0"),' "" \
      --replace-fail 'cache.join("cef_user_data"),' "" \
      --replace-fail 'config.join("cef_user_data"),' "" \
      --replace-fail 'let config = glib::user_config_dir();' ""
  '';

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    cef
  ];

  env.CEF_PATH = cef;

  # Assert that cef-dll-sys and karere-cef use the same CEF version.
  preConfigure = ''
    cefVersion=$(
      grep -A1 '^name = "cef-dll-sys"$' "$cargoDepsLockfile" |
        sed -nE 's/^version = ".*\+(.*)"$/\1/p'
    )

    if [ "$cefVersion" != "${cef.version}" ]; then
      echo "karere: Cargo.lock wants CEF '$cefVersion', but karere-cef is ${cef.version}" >&2
      exit 1
    fi
  '';

  passthru = {
    inherit cef;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Gtk4 Whatsapp client";
    homepage = "https://github.com/tobagin/karere";
    changelog = "https://github.com/tobagin/karere/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      marcel
      aleksana
    ];
    mainProgram = "karere";
    platforms = cef.meta.platforms;
  };
})
