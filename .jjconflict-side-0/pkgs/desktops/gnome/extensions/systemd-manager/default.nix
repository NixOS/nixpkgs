{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  glib,
  # These loosen security a bit, so we don't install them by default. See also:
  # https://github.com/hardpixel/systemd-manager?tab=readme-ov-file#without-password-prompt
  allowPolkitPolicy ? "none",
  config,
  systemd ? config.systemd.package,
}:

assert lib.elem allowPolkitPolicy [
  "none"
  "pkexec"
  "systemctl"
];

stdenvNoCC.mkDerivation rec {
  pname = "gnome-shell-extension-systemd-manager";
  version = "17";

  # Upstream doesn't post new versions in extensions.gnome.org anymore, see also:
  # https://github.com/hardpixel/systemd-manager/issues/19
  src = fetchFromGitHub {
    owner = "hardpixel";
    repo = "systemd-manager";
    rev = "v${version}";
    hash = "sha256-3cKjjKXc7lLG7PB8+8ExTRmC23uPRONUI3eEx+jTUVA=";
  };

  nativeBuildInputs = [ glib ];

  postInstall =
    ''
      rm systemd-manager@hardpixel.eu/schemas/gschemas.compiled
      glib-compile-schemas systemd-manager@hardpixel.eu/schemas

      mkdir -p $out/share/gnome-shell/extensions
      mv systemd-manager@hardpixel.eu $out/share/gnome-shell/extensions
    ''
    + lib.optionalString (allowPolkitPolicy == "pkexec") ''
      local bn=org.freedesktop.policykit.pkexec.systemctl.policy
      mkdir -p $out/share/polkit-1/actions
      substitute systemd-policies/$bn $out/share/polkit-1/actions/$bn \
        --replace-fail /usr/bin/systemctl ${lib.getBin systemd}/bin/systemctl
    ''
    + lib.optionalString (allowPolkitPolicy == "systemctl") ''
      install -Dm0644 \
        systemd-policies/10-service_status.rules \
        $out/share/polkit-1/rules.d/10-gnome-extension-systemd-manager.rules
    '';

  passthru = {
    extensionUuid = "systemd-manager@hardpixel.eu";
    extensionPortalSlug = "systemd-manager";
  };

  meta = with lib; {
    description = "GNOME Shell extension to manage systemd services";
    homepage = "https://github.com/hardpixel/systemd-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      linsui
      doronbehar
    ];
  };
}
