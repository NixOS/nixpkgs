{
  fetchFromGitHub,
  geoclue2-with-demo-agent,
  lib,
  libinput,
  pkg-config,
  rustPlatform,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-wwrbZJ/FA6qjeo9M/gIlzVyygiLT3R5OTLhTwr/QSSw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zAVBkH6ADs8uXqHD1gHQJl1e5l+g6NdnhEJa5fSvHDE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  postInstall = ''
    mkdir -p $out/share/{polkit-1/rules.d,cosmic/com.system76.CosmicSettings.Shortcuts/v1}
    cp data/polkit-1/rules.d/*.rules $out/share/polkit-1/rules.d/
    cp data/system_actions.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-settings-daemon";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
