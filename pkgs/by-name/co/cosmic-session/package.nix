{
  lib,
  fetchFromGitHub,
  bash,
  rustPlatform,
  just,
  dbus,
  stdenv,
  xdg-desktop-portal-cosmic,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-session";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-2EKkVdZ7uNNJ/E/3knmeH3EBa+tkYmIxP3t9d6yacww=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iYObxjWJUKgZKGTkqtYgQK4758k0EYZGhIAM/oLxxso=";

  postPatch = ''
    substituteInPlace data/start-cosmic \
      --replace-fail '/usr/bin/cosmic-session' "${placeholder "out"}/bin/cosmic-session" \
      --replace-fail '/usr/bin/dbus-run-session' "${lib.getBin dbus}/bin/dbus-run-session"
    substituteInPlace data/cosmic.desktop \
      --replace-fail '/usr/bin/start-cosmic' "${placeholder "out"}/bin/start-cosmic"
  '';

  buildInputs = [ bash ];
  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cosmic_dconf_profile"
    "cosmic"
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  env.XDP_COSMIC = "${xdg-desktop-portal-cosmic}/libexec/xdg-desktop-portal-cosmic";

  postInstall = ''
    dconf_profile_dst=$out/etc/dconf/profile/cosmic
    if [ ! -f $dconf_profile_dst ]; then
        install -Dm0644 data/dconf/profile/cosmic $dconf_profile_dst
    else
        # future proofing
        echo 'The Justfile is now correctly installing the dconf profile.'
        echo 'Please remove the dconf profile from the `postInstall` phase.'
        exit 1
    fi
  '';

  passthru.providedSessions = [ "cosmic" ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with lib.maintainers; [
      a-kenji
      nyabinary
      thefossguy
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
  };
})
